import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/model.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/init/flavor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../config_data.dart';
import '../mocks.dart';

void main() {
  late MockConfigProvider mockProvider;

  setUp(() {
    mockProvider = MockConfigProvider();
  });

  group('Staging Strategy Tests', () {
    ConfigSource createStagingStrategy() =>
        ConfigStrategyFactory.createStrategy(Flavor.staging(), mockProvider);

    test('Happy Path', () async {
      // ARRANGE
      const expectedConfigPath = '/config/getAppConfigStaging';
      final expectedFunctionsPath = minimalConfigData['functionsFilePath'];

      // Set up mocks
      when(() => mockProvider.getAppConfigFromNetwork(any()))
          .thenAnswer((_) async => minimalConfigData);
      when(() => mockProvider.initFunctions(
            remotePath: any(named: 'remotePath'),
            localPath: null,
            version: null,
          )).thenAnswer((_) async {});

      // ACT
      final DUIConfig config = await createStagingStrategy().getConfig();

      // ASSERT
      expect(
        config,
        isA<DUIConfig>(),
        reason: 'Config should be parsed successfully',
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
      when(() => mockProvider.getAppConfigFromNetwork(
          '/config/getAppConfigStaging')).thenThrow(Exception('Network error'));

      expect(
        () => createStagingStrategy().getConfig(),
        throwsA(isA<ConfigException>()
            .having(
                (e) => e.type, 'error type', equals(ConfigErrorType.network))
            .having((e) => e.message, 'message',
                contains('Failed to load config'))),
      );
    });
  });
}
