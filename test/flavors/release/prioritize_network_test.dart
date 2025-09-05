import 'dart:convert';
import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/init/flavor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../config_data.dart';
import '../../mocks.dart';

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

  ConfigSource createReleaseStrategy(DSLInitStrategy priority) {
    return ConfigStrategyFactory.createStrategy(
      Flavor.release(
        initStrategy: priority,
        appConfigPath: 'appConfig.json',
        functionsPath: 'functions.js',
      ),
      mockProvider,
    );
  }

  group('PrioritizeNetwork Strategy', () {
    test('PrioritizeNetwork - Happy Path', () async {
      // ARRANGE
      final Map<String, dynamic> newConfigData = Map.from(validConfigData)
        ..['version'] = 2
        ..['functionsFilePath'] = 'updatedFunctionPath';

      // Mock cache read to return initial config (version 1)
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      // Mock cache read to return initial config (version 1)
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      // Mock network call to return new config (version 2)
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => validNetworkConfigData);

      // Mock file download - this should return the actual bytes of the new config
      when(() => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          )).thenAnswer((_) async => Response(
            data: utf8.encode(json.encode(newConfigData)),
            requestOptions: RequestOptions(),
          ));

      // Mock cache write with the new config
      when(() => mockFileOps.writeBytesToFile(any(), 'appConfig.json'))
          .thenAnswer((_) async => true);

      // ACT
      final strategy =
          createReleaseStrategy(NetworkFirstStrategy(timeoutInMs: 5000));
      final config = await strategy.getConfig();

      // ASSERT
      // First, cache is checked
      verify(() => mockFileOps.readString('appConfig.json')).called(1);
      verify(() => mockAssetOps.readString(any())).called(1);

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

    test('Network Timeout - Fallback to Cache', () async {
      // ARRANGE
      // Mock cache read with valid config
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      // Mock network timeout
      when(() => mockProvider.getAppConfigFromNetwork(
          '/config/getAppConfigRelease')).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 2));
        return validNetworkConfigData;
      });

      // ACT
      final strategy =
          createReleaseStrategy(NetworkFirstStrategy(timeoutInMs: 1000));
      final config = await strategy.getConfig();

      // ASSERT
      // First tries network (times out)
      verify(() => mockProvider
          .getAppConfigFromNetwork('/config/getAppConfigRelease')).called(1);
      // Falls back to cache
      verify(() => mockFileOps.readString('appConfig.json')).called(1);

      verify(() => mockAssetOps.readString(any())).called(1);

      // Config should match cache values
      expect(config.version, equals(1));
      expect(config.functionsFilePath,
          equals(validConfigData['functionsFilePath']));

      // Verify no unnecessary operations

      // verifyNever(() => mockDownloadOps.downloadFile(any(), any()));
      verifyNoMoreInteractions(mockProvider.bundleOps);
    });

    test('Network Error -> Cache Fallback', () async {
      // Mock network failure
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenThrow(ConfigException('Network error'));

      // Mock cache success
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      // ACT
      final strategy =
          createReleaseStrategy(NetworkFirstStrategy(timeoutInMs: 1000));
      final config = await strategy.getConfig();

      verify(() => mockFileOps.readString('appConfig.json')).called(1);
      verify(() => mockAssetOps.readString('appConfig.json')).called(1);

      expect(config.version, equals(1));
      expect(config.functionsFilePath,
          equals(validConfigData['functionsFilePath']));

      // Verify no unnecessary operations
      // verifyNever(() => mockAssetOps.readString(any()));
      // verifyNever(() => mockDownloadOps.downloadFile(any(), any()));
      verifyNoMoreInteractions(mockProvider.bundleOps);
    });

    test('Network Error -> Cache Error -> Asset Fallback', () async {
      // Mock failures
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenThrow(ConfigException('Network error'));
      when(() => mockFileOps.readString('appConfig.json'))
          .thenThrow(ConfigException('Cache error'));

      // Mock asset success
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      // ACT
      final strategy =
          createReleaseStrategy(NetworkFirstStrategy(timeoutInMs: 5000));
      final config = await strategy.getConfig();

      verify(() => mockProvider
          .getAppConfigFromNetwork('/config/getAppConfigRelease')).called(1);
      verify(() => mockFileOps.readString('appConfig.json')).called(1);
      verify(() => mockAssetOps.readString('appConfig.json')).called(1);

      expect(config.version, equals(1));
      expect(config.functionsFilePath,
          equals(validConfigData['functionsFilePath']));

      // Verify no unnecessary operations
      verifyNever(() => mockDownloadOps.downloadFile(any(), any()));
      verifyNoMoreInteractions(mockProvider.bundleOps);
    });

    // test('All Sources Fail', () async {
    //   // Mock all failures
    //   when(() => mockProvider
    //           .getAppConfigFromNetwork('/config/getAppConfigRelease'))
    //       .thenThrow(ConfigException('Network error'));
    //   when(() => mockFileOps.readString('appConfig.json'))
    //       .thenThrow(ConfigException('Cache error'));
    //   when(() => mockAssetOps.readString('appConfig.json'))
    //       .thenThrow(ConfigException('Asset error'));

    //   final strategy = createReleaseStrategy(PrioritizeNetwork(5));

    //   expect(
    //     () => strategy.getConfig(),
    //     throwsA(isA<ConfigException>()
    //         .having((e) => e.message, 'message', 'All config sources failed')),
    //   );
    // });
  });
}
