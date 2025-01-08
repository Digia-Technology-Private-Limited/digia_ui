import 'dart:async';

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
  late MockDownloadOperations mockDownloadOps;
  late MockAssetBundleOperations mockAssetOps;

  setUp(() {
    mockProvider = MockConfigProvider();
    mockFileOps = MockFileOperations();
    mockDownloadOps = MockDownloadOperations();
    mockAssetOps = MockAssetBundleOperations();
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
          .thenAnswer((_) async => validConfigJson);

      final source =
          CachedConfigSource(mockProvider, 'config.json', fileOps: mockFileOps);
      final config = await source.getConfig();

      expect(config.version, equals(1));
    });

    test('cache corruption', () async {
      when(() => mockFileOps.readString('config.json'))
          .thenAnswer((_) async => 'invalid json');

      final source =
          CachedConfigSource(mockProvider, 'config.json', fileOps: mockFileOps);

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });
  });

  group('AssetConfigSource Tests', () {
    test('load and parse asset config', () async {
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenAnswer((_) async => validConfigJson);

      final source = AssetConfigSource(
          mockProvider, 'assets/config.json', 'assets/functions.js',
          bundleOps: mockAssetOps);

      final config = await source.getConfig();
      expect(config.version, equals(1));
    });

    test('missing asset', () async {
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenThrow(Exception('Asset not found'));

      final source = AssetConfigSource(
          mockProvider, 'assets/config.json', 'assets/functions.js',
          bundleOps: mockAssetOps);

      expect(() => source.getConfig(), throwsA(isA<ConfigException>()));
    });
  });

  group('NetworkFileConfigSource Tests', () {
    test('download and cache new version', () async {
      when(() => mockProvider.getAppConfigFromNetwork(any())).thenAnswer(
          (_) async => {
                'versionUpdated': true,
                'appConfigFileUrl': 'http://example.com/config'
              });
      when(() => mockDownloadOps.downloadFile(any(), any()))
          .thenAnswer((_) async => createMockResponse(validConfigData));

      final source = NetworkFileConfigSource(mockProvider, '/config/path',
          fileOps: mockFileOps);

      final config = await source.getConfig();
      expect(config.version, equals(1));
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
        () async => throw Exception('Delegate failed'),
      );

      expect(
        () => source.getConfig(),
        throwsA(isA<ConfigException>().having(
          (e) => e.message,
          'message',
          contains('Failed to execute config function'),
        )),
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
