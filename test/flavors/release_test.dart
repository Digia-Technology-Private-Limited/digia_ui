import 'dart:convert';
import 'dart:typed_data';

import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/environment.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../config_data.dart';
import '../mocks.dart';

void main() {
  late MockConfigProvider mockProvider;
  late MockFileOperations mockFileOps;
  late MockFileDownloader mockDownloadOps;
  late MockAssetBundleOperations mockAssetOps;

  setUp(() {
    mockProvider = MockConfigProvider();
    mockFileOps = MockFileOperations();
    mockDownloadOps = MockFileDownloader();
    mockAssetOps = MockAssetBundleOperations();

    // Setup provider getters
    when(() => mockProvider.fileOps).thenReturn(mockFileOps);
    when(() => mockProvider.downloadOps).thenReturn(mockDownloadOps);
    when(() => mockProvider.bundleOps).thenReturn(mockAssetOps);

    // Setup other mocked behaviors
    when(() => mockProvider.initFunctions(
          remotePath: any(named: 'remotePath'),
          localPath: any(named: 'localPath'),
          version: any(named: 'version'),
        )).thenAnswer((_) async {});
  });

  ConfigSource createReleaseStrategy(InitPriority priority) {
    return ConfigStrategyFactory.createStrategy(
      Release(priority, 'appConfig.json', 'functions.js'),
      mockProvider,
    );
  }

  group('Release Strategy - PrioritizeNetwork', () {
    test('PrioritizeNetwork - Happy Path2 sad', () async {
      // ARRANGE
      final Map<String, dynamic> newConfigData = Map.from(validConfigData)
        ..['version'] = 2
        ..['functionsFilePath'] = 'updatedFunctionPath';

      // Mock cache read to return initial config (version 1)
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      // Mock network call to return new config (version 2)
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => validNetworkConfigData);

      // Mock setting version header
      when(() => mockProvider.addVersionHeader(1)).thenReturn(null);

      // Mock file download - this should return the actual bytes of the new config
      final Uint8List mockDownloadedBytes =
          utf8.encode(json.encode(newConfigData));
      when(() => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          )).thenAnswer((_) async => Response(
            data: mockDownloadedBytes,
            requestOptions: RequestOptions(),
          ));

      // Mock cache write with the new config
      when(() => mockFileOps.writeBytesToFile(any(), 'appConfig.json'))
          .thenAnswer((_) async => true);

      // ACT
      final strategy = createReleaseStrategy(PrioritizeNetwork(5));
      final config = await strategy.getConfig();

      // ASSERT

      // TODO: Use verifyInOrder instead of verify
      // First, cache is checked
      verify(() => mockFileOps.readString('appConfig.json')).called(1);

      // Then version header is set from cached config
      verify(() => mockProvider.addVersionHeader(1)).called(1);

      // Network call is made with the version header
      verify(() => mockProvider
          .getAppConfigFromNetwork('/config/getAppConfigRelease')).called(1);

      // Download the new config
      verify(() => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          ));

      // Write the new config to cache
      verify(() => mockProvider.fileOps
          .writeBytesToFile(captureAny(), 'appConfig.json')).called(1);

      // Verify final config values
      expect(config.version, equals(2));
      expect(config.functionsFilePath, equals('updatedFunctionPath'));
    });

    test('PrioritizeCache - Happy Path', () async {
      // ARRANGE
      final burnedConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 3
        ..['functionsFilePath'] = 'burnedPath';

      final cacheConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 2
        ..['functionsFilePath'] = 'cachedPath';

      final networkConfig = Map<String, dynamic>.from(validNetworkConfigData)
        ..['version'] = 3
        ..['functionsFilePath'] = 'networkPath'
        ..['appConfigFileUrl'] = 'downloadUrl';

      final donwloadedConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 3
        ..['functionsFilePath'] = 'networkPath';

      // Mock burned config
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode({
                'isSuccess': true,
                'data': {'response': burnedConfig}
              }));

      // Mock cache operations
      when(() => mockFileOps.exists('appConfig.json'))
          .thenAnswer((_) async => true);
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(cacheConfig));

      // Mock network operations
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => networkConfig);

      // Mock download operations
      final Uint8List mockDownloadedBytes =
          utf8.encode(json.encode(donwloadedConfig));
      when(() => mockDownloadOps.downloadFile(
            networkConfig['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          )).thenAnswer((_) async => Response(
            data: mockDownloadedBytes,
            requestOptions: RequestOptions(),
          ));

      // Mock cache write
      when(() => mockFileOps.writeStringToFile(any(), 'appConfig.json'))
          .thenAnswer((_) async => true);

      // ACT
      final strategy = createReleaseStrategy(PrioritizeCache());
      final config = await strategy.getConfig();

      // ASSERT - Immediate Operations
      // Version comparison
      verify(() => mockAssetOps.readString('appConfig.json')).called(1);
      verify(() => mockFileOps.readString('appConfig.json')).called(2);
      // Network call started
      verify(() => mockProvider
          .getAppConfigFromNetwork('/config/getAppConfigRelease')).called(1);

      // Verify immediate config return
      expect(config.version, equals(2));
      expect(config.functionsFilePath, equals('cachedPath'));

      // ASSERT - Background Operations
      await Future.delayed(Duration.zero);

      verify(() =>
              mockDownloadOps.downloadFile('downloadUrl', 'appConfig.json'))
          .called(1);
      verify(() =>
              mockProvider.fileOps.writeStringToFile(any(), 'appConfig.json'))
          .called(3);
    });

    test('PrioritizeLocal - Happy Path2', () async {
      // ARRANGE
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => validConfigJson);

      // ACT
      final strategy = createReleaseStrategy(PrioritizeLocal());
      final config = await strategy.getConfig();

      // ASSERT
      verifyInOrder([
        // Verify only asset read is called
        () => mockAssetOps.readString('appConfig.json'),
        // Verify functions initialization
        () => mockProvider.initFunctions(localPath: 'functions.js'),
      ]);

      // Verify config values from validConfigData
      expect(config.version, equals(1));
      expect(config.functionsFilePath, equals('testPathToFunctionFile'));

      // Verify no cache/network/download operations occurred
      verifyZeroInteractions(mockFileOps);
      verifyZeroInteractions(mockDownloadOps);
      verifyNever(() => mockFileOps.readString(any()));
      verifyNever(() => mockDownloadOps.downloadFile(any(), any()));
      verifyNever(() => mockProvider.getAppConfigFromNetwork(any()));
      // verifyNoMoreInteractions(mockProvider);
    });
  });
}
