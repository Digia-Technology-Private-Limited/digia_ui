import 'dart:async';
import 'dart:convert';

import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/model.dart';
import 'package:digia_ui/src/config/source/asset.dart';
import 'package:digia_ui/src/config/source/cache.dart';
import 'package:digia_ui/src/config/source/delegated.dart';
import 'package:digia_ui/src/config/source/fallback.dart';
import 'package:digia_ui/src/config/source/network.dart';
import 'package:digia_ui/src/config/source/network_file.dart';
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

    when(() => mockProvider.bundleOps).thenReturn(mockAssetOps);
    when(() => mockProvider.fileOps).thenReturn(mockFileOps);
    when(() => mockProvider.downloadOps).thenReturn(mockDownloadOps);
    when(() => mockProvider.initFunctions(
          remotePath: any(named: 'remotePath'),
          localPath: any(named: 'localPath'),
          version: any(named: 'version'),
        )).thenAnswer((_) async {});
  });

  group('NetworkConfigSource Tests', () {
    test('successful fetch and parse', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async => validConfigData);

      final source = NetworkConfigSource(mockProvider, '/config/path');
      final config = await source.getConfig();

      expect(config.version, equals(1));
      verify(() =>
              mockProvider.initFunctions(remotePath: any(named: 'remotePath')))
          .called(1);
    });

    test('timeout handling', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 6));
        return validConfigData;
      });

      final source = NetworkConfigSource(mockProvider, '/config/path',
          timeout: Duration(seconds: 5));

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });
  });

  group('CachedConfigSource Tests', () {
    test('cache hit with valid data', () async {
      when(() => mockFileOps.readString('config.json'))
          .thenAnswer((_) async => json.encode(validConfigData));

      final source = CachedConfigSource(mockProvider, 'config.json');
      final config = await source.getConfig();

      expect(config.version, equals(1));
    });

    test('cache corruption', () async {
      when(() => mockFileOps.readString('config.json'))
          .thenAnswer((_) async => 'invalid json');

      final source = CachedConfigSource(mockProvider, 'config.json');

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });
  });

  group('AssetConfigSource Tests', () {
    test('load and parse asset config', () async {
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenAnswer((_) async => validConfigJson);

      final source = AssetConfigSource(
        mockProvider,
        'assets/config.json',
        'assets/functions.js',
      );

      final config = await source.getConfig();
      expect(config.version, equals(1));
    });

    test('missing asset', () async {
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenThrow(Exception('Asset not found'));

      final source = AssetConfigSource(
        mockProvider,
        'assets/config.json',
        'assets/functions.js',
      );

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });
  });

  group('NetworkFileConfigSource Tests', () {
    test('download and cache new version', () async {
      when(() => mockProvider.getAppConfigFromNetwork(
          '/config/getAppConfigRelease')).thenAnswer((_) async {
        validNetworkConfigData['versionUpdated'] = true;
        validNetworkConfigData['version'] = 2;
        return validNetworkConfigData;
      });
      when(
        () => mockDownloadOps.downloadFile(
            validNetworkConfigData['appConfigFileUrl'] as String,
            'appConfig.json'),
      ).thenAnswer((_) async => createMockResponse(validConfigData));

      final source = NetworkFileConfigSource(
        mockProvider,
        '/config/getAppConfigRelease',
      );

      final config = await source.getConfig();
      expect(config.version, equals(1));
    });

    test('should handle network error', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenThrow(ConfigException('Network error'));

      final source = NetworkFileConfigSource(
        mockProvider,
        '/config/getAppConfigRelease',
      );

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });

    test('should handle invalid file url', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async => {'appConfigFileUrl': null});

      final source = NetworkFileConfigSource(
        mockProvider,
        '/config/getAppConfigRelease',
      );

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });

    test('should handle download failure', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async => validNetworkConfigData);
      when(() => mockDownloadOps.downloadFile(any(), any()))
          .thenThrow(ConfigException('Download failed'));

      final source = NetworkFileConfigSource(
        mockProvider,
        '/config/getAppConfigRelease',
      );

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });

    test('should handle timeout', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 6));
        return validNetworkConfigData;
      });

      final source = NetworkFileConfigSource(
        mockProvider,
        '/config/getAppConfigRelease',
        timeout: const Duration(seconds: 5),
      );

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });
  });

  group('FallbackConfigSource Tests', () {
    late MockConfigSource primarySource;
    late MockConfigSource fallbackSource1;
    late MockConfigSource fallbackSource2;

    setUp(() {
      primarySource = MockConfigSource();
      fallbackSource1 = MockConfigSource();
      fallbackSource2 = MockConfigSource();
    });

    test('primary source success', () async {
      when(() => primarySource.getConfig())
          .thenAnswer((_) async => DUIConfig(validConfigData));

      final source = FallbackConfigSource(
        primary: primarySource,
        fallback: [fallbackSource1, fallbackSource2],
      );

      final config = await source.getConfig();
      expect(config, isA<DUIConfig>());
      verifyNever(() => fallbackSource1.getConfig());
    });

    test('primary fails, first fallback succeeds', () async {
      when(() => primarySource.getConfig())
          .thenThrow(ConfigException('Primary failed'));
      when(() => fallbackSource1.getConfig())
          .thenAnswer((_) async => DUIConfig(validConfigData));

      final source = FallbackConfigSource(
        primary: primarySource,
        fallback: [fallbackSource1, fallbackSource2],
      );

      final config = await source.getConfig();
      expect(config, isA<DUIConfig>());
      verify(() => fallbackSource1.getConfig()).called(1);
      verifyNever(() => fallbackSource2.getConfig());
    });

    test('all sources fail', () async {
      when(() => primarySource.getConfig())
          .thenThrow(ConfigException('Primary failed'));
      when(() => fallbackSource1.getConfig())
          .thenThrow(ConfigException('Fallback 1 failed'));
      when(() => fallbackSource2.getConfig())
          .thenThrow(ConfigException('Fallback 2 failed'));

      final source = FallbackConfigSource(
        primary: primarySource,
        fallback: [fallbackSource1, fallbackSource2],
      );

      expect(
        () => source.getConfig(),
        throwsA(isA<ConfigException>()
            .having((e) => e.message, 'message', 'All config sources failed')),
      );
    });

    test('empty fallback list', () async {
      when(() => primarySource.getConfig())
          .thenThrow(ConfigException('Primary failed'));

      final source = FallbackConfigSource(primary: primarySource);

      expect(
        () => source.getConfig(),
        throwsA(isA<ConfigException>()),
      );
    });
  });

  group('DelegatedConfigSource Tests', () {
    test('successful delegation', () async {
      final source = DelegatedConfigSource(
        () async => DUIConfig(validConfigData),
      );

      final config = await source.getConfig();
      expect(config, isA<DUIConfig>());
      expect(config.version, equals(1));
    });

    test('delegation error', () async {
      final source = DelegatedConfigSource(
        () async => throw ConfigException('Delegate failed'),
      );

      expect(
        () => source.getConfig(),
        throwsA(isA<ConfigException>()),
      );
    });

    test('timeout handling', () async {
      final source = DelegatedConfigSource(() async {
        await Future.delayed(const Duration(seconds: 5));
        return DUIConfig(validConfigData);
      });

      expect(
        () => source.getConfig().timeout(const Duration(seconds: 2)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('null safety', () async {
      final source = DelegatedConfigSource(
        () async => DUIConfig({}),
      );

      final config = await source.getConfig();
      expect(config, isA<DUIConfig>());
    });
  });
}
