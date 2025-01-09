import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/environment.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../config_data.dart';
import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConfigProvider mockProvider;
  late MockFileOperations mockFileOps;
  late MockDownloadOperations mockDownloadOps;
  late MockAssetBundleOperations mockAssetOps;

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async => 'test',
  );

  setUp(() {
    mockProvider = MockConfigProvider();
    mockFileOps = MockFileOperations();
    mockDownloadOps = MockDownloadOperations();
    mockAssetOps = MockAssetBundleOperations();

    when(() => mockFileOps.exists(any())).thenAnswer((_) async => true);
    when(() => mockProvider.initFunctions(
          remotePath: any(named: 'remotePath'),
          localPath: any(named: 'localPath'),
          version: any(named: 'version'),
        )).thenAnswer((_) async {});
  });

  ConfigSource createReleaseStrategy(InitPriority priority) {
    return ConfigStrategyFactory.createStrategy(
      Release(priority, 'assets/config.json', 'functions.js'),
      mockProvider,
    );
  }

  group('Release Strategy - PrioritizeNetwork', () {
    test('successful path - cache then network', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => validConfigJson);
      when(() => mockDownloadOps.downloadFile(any(), any()))
          .thenAnswer((_) async => Response(
              data: validConfigData,
              requestOptions: RequestOptions(
                path: '/config/getAppConfigRelease',
              )));

      final strategy = createReleaseStrategy(PrioritizeNetwork(5));
      final config = await strategy.getConfig();

      verifyInOrder([
        () => mockFileOps.readString('appConfig.json'),
        () =>
            mockDownloadOps.downloadFile('/config/getAppConfigRelease', any()),
      ]);
      expect(config.version, equals(1));
    });

    test('network timeout fallback to cache', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => validConfigJson);
      when(() => mockDownloadOps.downloadFile(any(), any()))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 6));
        return Response(
            data: validConfigData, requestOptions: RequestOptions());
      });

      final strategy = createReleaseStrategy(PrioritizeNetwork(5));
      final config = await strategy.getConfig();

      verify(() => mockFileOps.readString('appConfig.json')).called(1);
      expect(config.version, equals(1));
    });

    test('full fallback chain - cache -> network -> asset', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenThrow(ConfigException('No cache'));
      when(() => mockDownloadOps.downloadFile(any(), any()))
          .thenThrow(Exception('Network error'));
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenAnswer((_) async => validConfigJson);

      final strategy = createReleaseStrategy(PrioritizeNetwork(5));
      final config = await strategy.getConfig();

      verifyInOrder([
        () => mockFileOps.readString('appConfig.json'),
        () =>
            mockDownloadOps.downloadFile('/config/getAppConfigRelease', any()),
        () => mockAssetOps.readString('assets/config.json'),
      ]);

      expect(config.version, equals(1));
    });
  });

  group('Release Strategy - PrioritizeCache', () {
    test('cache hit - no network call', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => validConfigJson);

      final strategy = createReleaseStrategy(PrioritizeCache());
      final config = await strategy.getConfig();

      verify(() => mockFileOps.readString('appConfig.json')).called(1);
      verifyNever(() => mockDownloadOps.downloadFile(any(), any()));

      expect(config.version, equals(1));
    });

    test('cache miss - fallback chain', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenThrow(ConfigException('No cache'));
      when(() => mockDownloadOps.downloadFile(any(), any())).thenAnswer(
          (_) async => Response(
              data: validConfigData, requestOptions: RequestOptions()));

      final strategy = createReleaseStrategy(PrioritizeCache());
      await strategy.getConfig();

      verifyInOrder([
        () => mockFileOps.readString('appConfig.json'),
        () =>
            mockDownloadOps.downloadFile('/config/getAppConfigRelease', any()),
      ]);
    });
  });

  group('Release Strategy - PrioritizeLocal', () {
    test('asset only - no cache/network', () async {
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenAnswer((_) async => validConfigJson);

      final strategy = createReleaseStrategy(PrioritizeLocal());
      final config = await strategy.getConfig();

      verify(() => mockAssetOps.readString('assets/config.json')).called(1);
      verifyNever(() => mockFileOps.readString(any()));
      verifyNever(() => mockDownloadOps.downloadFile(any(), any()));

      expect(config.version, equals(1));
    });

    test('asset failure', () async {
      when(() => mockAssetOps.readString('assets/config.json'))
          .thenThrow(Exception('Asset not found'));

      final strategy = createReleaseStrategy(PrioritizeLocal());

      expect(
          () => strategy.getConfig(),
          throwsA(isA<ConfigException>().having((e) => e.message, 'message',
              contains('Asset config not found'))));
    });
  });

  group('Error Handling', () {
    test('invalid json from any source', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => 'invalid json');

      final strategy = createReleaseStrategy(PrioritizeCache());

      expect(() => strategy.getConfig(), throwsA(isA<ConfigException>()));
    });

    test('version header handling', () async {
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => validConfigJson);

      final strategy = createReleaseStrategy(PrioritizeNetwork(5));
      await strategy.getConfig();

      verify(() => mockProvider.addVersionHeader(1)).called(1);
    });
  });
}
