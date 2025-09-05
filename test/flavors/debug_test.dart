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

  /// getAppConfigFromNetwork
  /// 1. getAppConfigFromNetwork must be called exactly once
  /// 2. getAppConfigFromNetwork should have captured 1 arg: '/config/getAppConfig'
  ///
  /// Init Functions:
  /// 1. initFunctions must be called exactly once
  /// 2. initFunctions should have captured 1 arg: minimalConfigData['functionsFilePath']

  group('Debug Strategy Tests', () {
    ConfigSource createStrategy() => ConfigStrategyFactory.createStrategy(
        Flavor.debug(branchName: null), mockProvider);

    test('Happy Path', () async {
      // ARRANGE
      const expectedConfigPath = '/config/getAppConfig';
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
      final DUIConfig config = await createStrategy().getConfig();

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
      when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
          .thenThrow(Exception('Network error'));

      expect(
        () => createStrategy().getConfig(),
        throwsA(isA<ConfigException>()
            .having((e) => e.type, 'type', ConfigErrorType.network)
            .having((e) => e.message, 'message',
                contains('Failed to load config'))),
      );
    });
  });
}
