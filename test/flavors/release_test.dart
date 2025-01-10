import 'dart:convert';

import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/environment.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockConfigProvider mockProvider;
  // late MockFileOperations mockFileOps;
  // late MockDownloadOperations mockDownloadOps;
  // late MockAssetBundleOperations mockAssetOps;

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (MethodCall methodCall) async => 'test',
  );

  setUp(() {
    mockProvider = MockConfigProvider();
    // mockFileOps = MockFileOperations();
    // mockDownloadOps = MockDownloadOperations();
    // mockAssetOps = MockAssetBundleOperations();

    // when(() => mockFileOps.exists(any())).thenAnswer((_) async => true);
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
    test('PrioritizeNetwork - Happy Path', () async {
      // ARRANGE
      // 1. Initial cached config
      final initialConfig = {
        'appSettings': {'initialRoute': 'home'},
        'pages': {},
        'theme': {
          'colors': {'light': {}},
          'fonts': {}
        },
        'rest': {'defaultHeaders': {}},
        'functionsFilePath': 'initialPath',
        'version': 1
      };

      // 2. Network config
      final networkConfig = {
        'appSettings': {'initialRoute': 'home'},
        'pages': {},
        'theme': {
          'colors': {'light': {}},
          'fonts': {}
        },
        'rest': {'defaultHeaders': {}},
        'functionsFilePath': 'updatedPath',
        'version': 2
      };

      // 3. Setup mocks
      final mockProvider = MockConfigProvider();
      final mockFileOps = MockFileOperations();
      final mockBundleOps = MockAssetBundleOperations();

      // Setup provider operations
      when(() => mockProvider.fileOps).thenReturn(mockFileOps);
      when(() => mockProvider.bundleOps).thenReturn(mockBundleOps);

      // Cache operations
      when(() => mockFileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(initialConfig));
      when(() => mockFileOps.writeStringToFile(any(), any()))
          .thenAnswer((_) async => true);

      // Asset operations (fallback)
      when(() => mockBundleOps.readString(any()))
          .thenAnswer((_) async => json.encode({
                'data': {'response': initialConfig}
              }));

      // Network operations
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => networkConfig);

      // Functions initialization
      when(() => mockProvider.initFunctions(
            remotePath: any(named: 'remotePath'),
            version: any(named: 'version'),
          )).thenAnswer((_) async {});

      // ACT
      final strategy = createReleaseStrategy(PrioritizeNetwork(5));
      final config = await strategy.getConfig();

      // ASSERT
      verifyInOrder([
        // Initial config fetch (cache)
        () => mockProvider.fileOps.readString('appConfig.json'),
        // Version header set
        () => mockProvider.addVersionHeader(1),
        // Network config fetch
        () =>
            mockProvider.getAppConfigFromNetwork('/config/getAppConfigRelease'),
        // Cache update
        () => mockFileOps.writeStringToFile(any(), 'appConfig.json'),
      ]);

      // Verify final config
      expect(config.version, equals(2));
      expect(config.functionsFilePath, equals('updatedPath'));

      // Verify call counts
      verify(() => mockProvider.addVersionHeader(1)).called(1);
      verify(() => mockFileOps.writeStringToFile(any(), 'appConfig.json'))
          .called(1);
    });

    test('PrioritizeCache - Happy Path', () async {
      // ARRANGE
      final cachedConfig = {
        'data': {
          'response': {
            'appSettings': {'initialRoute': 'home'},
            'pages': {},
            'theme': {
              'colors': {'light': {}},
              'fonts': {}
            },
            'rest': {'defaultHeaders': {}},
            'functionsFilePath': 'cachedPath',
            'version': 1
          }
        }
      };

      final networkConfig = {
        'data': {
          'response': {
            'appSettings': {'initialRoute': 'home'},
            'pages': {},
            'theme': {
              'colors': {'light': {}},
              'fonts': {}
            },
            'rest': {'defaultHeaders': {}},
            'functionsFilePath': 'networkPath',
            'version': 2
          }
        }
      };

      // Setup cache operations
      when(() => mockProvider.fileOps.exists('appConfig.json'))
          .thenAnswer((_) async => true);
      when(() => mockProvider.fileOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(cachedConfig));

      // Setup asset operations (fallback)
      when(() => mockProvider.bundleOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(cachedConfig));

      // Setup network operations
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigRelease'))
          .thenAnswer((_) async => networkConfig);

      // Setup functions initialization
      when(() => mockProvider.initFunctions(
            remotePath: any(named: 'remotePath'),
            version: any(named: 'version'),
            localPath: any(named: 'localPath'),
          )).thenAnswer((_) async {});

      // ACT
      final strategy = createReleaseStrategy(PrioritizeCache());
      final config = await strategy.getConfig();

      // ASSERT
      // Verify cache was read
      verify(() => mockProvider.fileOps.readString('appConfig.json')).called(1);

      // Verify network call was made (but result not used)
      verify(() => mockProvider
          .getAppConfigFromNetwork('/config/getAppConfigRelease')).called(1);

      // Config should match cache (not network) values
      expect(config.version, equals(1));
      expect(config.functionsFilePath, equals('cachedPath'));

      // Verify functions initialized with cache values
      verify(() => mockProvider.initFunctions(
            remotePath: 'cachedPath',
            version: 1,
          )).called(1);
    });

    test('PrioritizeLocal - Happy Path', () async {
      // ARRANGE
      final assetConfig = {
        'data': {
          'response': {
            'appSettings': {'initialRoute': 'home'},
            'pages': {},
            'theme': {
              'colors': {'light': {}},
              'fonts': {}
            },
            'rest': {'defaultHeaders': {}},
            'functionsFilePath': 'localPath',
            'version': 1
          }
        }
      };

      // Setup asset bundle operations
      when(() => mockProvider.bundleOps.readString('appConfig.json'))
          .thenAnswer((_) async => json.encode(assetConfig));

      // Setup functions initialization
      when(() => mockProvider.initFunctions(
            localPath: any(named: 'localPath'),
          )).thenAnswer((_) async {});

      // ACT
      final strategy = createReleaseStrategy(PrioritizeLocal());
      final config = await strategy.getConfig();

      // ASSERT
      // Verify asset read
      verify(() => mockProvider.bundleOps.readString('appConfig.json'))
          .called(1);

      // Verify config values
      expect(config.version, equals(1));
      expect(config.functionsFilePath, equals('localPath'));

      // Verify functions initialized with local path
      verify(() => mockProvider.initFunctions(
            localPath: 'functions.js',
          )).called(1);

      // Verify no cache/network operations
      verifyNever(() => mockProvider.fileOps.readString(any()));
      verifyNever(() => mockProvider.getAppConfigFromNetwork(any()));
    });
  });
}
