import 'dart:convert';

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

  group('PrioritizeCache Strategy', () {
    test('PreferCache - Cache > Burned', () async {
      // ARRANGE
      final burnedConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 1
        ..['functionsFilePath'] = 'burnedPath';

      final cacheConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 2
        ..['functionsFilePath'] = 'cachedPath';

      // Mock configs
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(burnedConfig));
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(cacheConfig));
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => validNetworkConfigData);

      when(() => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          )).thenAnswer((_) async => Response(
            data: utf8.encode(json.encode(cacheConfig)),
            requestOptions: RequestOptions(),
          ));

      // ACT
      final strategy = createReleaseStrategy(CacheFirstStrategy());
      final config = await strategy.getConfig();

      // ASSERT
      verifyInOrder([
        // Version comparison
        () => mockAssetOps.readString('appConfig.json'),
        () => mockFileOps.readString('appConfig.json'),
        // Network update started
        () =>
            mockProvider.getAppConfigFromNetwork('/config/getAppConfigRelease'),
      ]);

      // Verify config values
      expect(config.version, equals(2));
      expect(config.functionsFilePath, equals('cachedPath'));

      // Verify no unnecessary operations
      verifyNever(() => mockFileOps.delete('appConfig.json'));
      verifyNever(() => mockProvider.initFunctions());

      // Allow background operations to complete
      await Future.delayed(Duration.zero);

      // Downloaded config written to cache
      verify(() => mockDownloadOps.downloadFile(any(), any())).called(1);
      verifyNoMoreInteractions(mockDownloadOps);
    });

    test('PreferCache - Cache < Burned', () async {
      // ARRANGE
      final burnedConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 3
        ..['functionsFilePath'] = 'burnedPath';

      final cacheConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 1
        ..['functionsFilePath'] = 'cachedPath';

      // Mock burned config (asset)
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(burnedConfig));

      // Mock cache operations
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(cacheConfig));
      when(() => mockFileOps.delete('appConfig.json'))
          .thenAnswer((_) async => true);

      // Mock network operations (happens in background)
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => validNetworkConfigData);
      when(() => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          )).thenAnswer((_) async => Response(
            data: utf8.encode(json.encode(burnedConfig)),
            requestOptions: RequestOptions(),
          ));

      // ACT
      final strategy = createReleaseStrategy(CacheFirstStrategy());
      final config = await strategy.getConfig();

      // ASSERT
      verifyInOrder([
        // Version comparison
        () => mockAssetOps.readString('appConfig.json'),
        () => mockFileOps.readString('appConfig.json'),
        // Cache purged due to lower version
        () => mockFileOps.delete('appConfig.json'),
        // Network update started
        () =>
            mockProvider.getAppConfigFromNetwork('/config/getAppConfigRelease'),
      ]);

      // Config should match burned version after cache purge
      expect(config.version, equals(3));
      expect(config.functionsFilePath, equals('burnedPath'));

      // Verify no unnecessary operations
      verifyNever(() => mockProvider.initFunctions());

      // Allow background operations to complete
      await Future.delayed(Duration.zero);

      // Downloaded config written to cache
      verify(() => mockDownloadOps.downloadFile(any(), any())).called(1);

      verifyNoMoreInteractions(mockDownloadOps);
    });

    test('Cache Empty - Use Asset', () async {
      // ARRANGE
      final burnedConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = 1
        ..['functionsFilePath'] = 'burnedPath';

      when(() => mockFileOps.exists('appConfig.json'))
          .thenAnswer((_) async => false);
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(burnedConfig));
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => validNetworkConfigData);
      when(() => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json',
            retry: 0,
          )).thenAnswer((_) async => Response(
            data: utf8.encode(json.encode(burnedConfig)),
            requestOptions: RequestOptions(),
          ));

      // ACT
      final strategy = createReleaseStrategy(CacheFirstStrategy());
      final config = await strategy.getConfig();

      // ASSERT
      verify(() => mockProvider.fileOps.exists('appConfig.json')).called(1);
      verify(() => mockAssetOps.readString('appConfig.json')).called(1);
      verify(() => mockProvider
          .getAppConfigFromNetwork('/config/getAppConfigRelease')).called(1);

      // Verify immediate config (from asset)
      expect(config.version, equals(1));
      expect(config.functionsFilePath, equals('burnedPath'));

      // Verify no unnecessary operations
      verifyNever(() => mockFileOps.delete(any()));

      // Allow background operations to complete
      await Future.delayed(Duration.zero);

      // Verify network update completed
      verify(() => mockDownloadOps.downloadFile(any(), any())).called(1);
    });

    test('Both Cache and Asset Corrupted During App Update - Should Throw',
        () async {
      // ARRANGE
      // Mock corrupted cache
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => 'invalid json');

      // Mock corrupted asset
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => 'invalid asset json');

      // ACT & ASSERT
      final strategy = createReleaseStrategy(CacheFirstStrategy());
      expect(
        () async => await strategy.getConfig(),
        throwsA(isA<FormatException>()),
        reason: 'Should throw when both cache and asset are corrupted',
      );
    });
  });
}
