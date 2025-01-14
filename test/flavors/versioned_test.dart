import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/model.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../config_data.dart';
import '../mocks.dart';

void main() {
  late MockConfigProvider mockProvider;

  setUp(() {
    mockProvider = MockConfigProvider();
  });

  group('Versioned Strategy Tests', () {
    ConfigSource createVersionedStrategy(int version) =>
        ConfigStrategyFactory.createStrategy(Versioned(version), mockProvider);

    test('Happy Path: Config with specific version', () async {
      // ARRANGE
      const expectedVersion = 2;
      const expectedConfigPath = '/config/getAppConfigForVersion';
      final expectedFunctionsPath = validConfigData['functionsFilePath'];
      final versionedConfig = Map<String, dynamic>.from(validConfigData)
        ..['version'] = expectedVersion;

      // Set up mocks
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async => versionedConfig);

      when(() => mockProvider.initFunctions(
            remotePath: any(named: 'remotePath'),
            localPath: null,
            version: null,
          )).thenAnswer((_) async {});

      when(() => mockProvider.addVersionHeader(any())).thenAnswer((_) async {});

      // ACT
      final config = await createVersionedStrategy(expectedVersion).getConfig();

      // ASSERT
      expect(
        config,
        isA<DUIConfig>(),
        reason: 'Should return a valid DUIConfig object',
      );
      expect(
        config.version,
        equals(expectedVersion),
        reason: 'Config should have the correct version',
      );

      // Verify getAppConfigFromNetwork
      final networkCall =
          verify(() => mockProvider.getAppConfigFromNetwork(captureAny()));
      networkCall.called(1);
      expect(
        networkCall.captured.single,
        expectedConfigPath,
        reason:
            'getAppConfigFromNetwork should be called with correct config path',
      );

      // Verify addVersionHeader
      final addVersionHeader =
          verify(() => mockProvider.addVersionHeader(captureAny()));
      addVersionHeader.called(1);
      expect(
        addVersionHeader.captured.single,
        expectedVersion,
        reason: 'addVersionHeader should be called with correct version',
      );

      // Verify initFunctions
      final initializeFunction = verify(() => mockProvider.initFunctions(
            remotePath: captureAny(named: 'remotePath'),
            localPath: null,
            version: null,
          ));
      initializeFunction.called(1);
      expect(
        initializeFunction.captured.single,
        expectedFunctionsPath,
        reason: 'initFunctions should be called with correct functions path',
      );
    });

    test('Network Error', () async {
      when(() => mockProvider
              .getAppConfigFromNetwork('/config/getAppConfigForVersion'))
          .thenThrow(Exception('Network error'));

      expect(
        () => createVersionedStrategy(1).getConfig(),
        throwsA(isA<ConfigException>()
            .having((e) => e.type, 'type', equals(ConfigErrorType.network))),
      );
    });
  });
}
