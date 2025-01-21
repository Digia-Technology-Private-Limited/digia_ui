import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/environment.dart';
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
  });

  ConfigSource createReleaseStrategy(InitPriority priority) {
    return ConfigStrategyFactory.createStrategy(
      Release(priority, 'appConfig.json', 'functions.js'),
      mockProvider,
    );
  }

  group('PrioritizeLocal Strategy', () {
    test('PrioritizeLocal - Happy Path', () async {
      // ARRANGE
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenAnswer((_) async => validConfigJson);
      when(() => mockProvider.initFunctions(
            localPath: any(named: 'localPath'),
            remotePath: null,
            version: null,
          )).thenAnswer((_) async {});

      // ACT
      final strategy = createReleaseStrategy(PrioritizeLocal());
      final config = await strategy.getConfig();

      // ASSERT
      expect(config.version, equals(1));
      expect(config.functionsFilePath, equals('testPathToFunctionFile'));

      // Verify asset read
      final assetReadCall =
          verify(() => mockAssetOps.readString('appConfig.json'));
      assetReadCall.called(1);
      expect(assetReadCall, isNotNull);

      // Verify functions initialization
      final initFunctionsCall = verify(() => mockProvider.initFunctions(
            localPath: captureAny(named: 'localPath'),
            remotePath: null,
            version: null,
          ));
      initFunctionsCall.called(1);
      expect(initFunctionsCall.captured.single, equals('functions.js'));

      // Verify no cache/network/download operations occurred
      verifyZeroInteractions(mockFileOps);
      verifyZeroInteractions(mockDownloadOps);
      verifyNoMoreInteractions(mockProvider.bundleOps);
      verifyNever(() => mockFileOps.readString(any()));
      verifyNever(() => mockDownloadOps.downloadFile(any(), any()));
      verifyNever(() => mockProvider.getAppConfigFromNetwork(any()));
    });

    test('Failure - Asset Read Error', () async {
      when(() => mockAssetOps.readString('appConfig.json'))
          .thenThrow(ConfigException('Asset read failed'));

      final strategy = createReleaseStrategy(PrioritizeLocal());

      expect(() => strategy.getConfig(), throwsA(isA<ConfigException>()));
    });
  });
}
