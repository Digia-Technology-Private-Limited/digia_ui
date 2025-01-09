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

  group('Staging Strategy Tests', () {
    ConfigSource createStagingStrategy() =>
        ConfigStrategyFactory.createStrategy(Staging(), mockProvider);

    group('Success scenarios', () {
      test('complete config', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigStaging'))
            .thenAnswer((_) async => validConfigData);
        when(() => mockProvider.initFunctions(
            remotePath: 'path/to/functions',
            localPath: null,
            version: null)).thenAnswer((_) async {});

        final DUIConfig config = await createStagingStrategy().getConfig();

        expect(config, isA<DUIConfig>());
        expect(config.version, equals(1));
        verify(() => mockProvider
            .getAppConfigFromNetwork('/config/getAppConfigStaging')).called(1);
        verify(() =>
                mockProvider.initFunctions(remotePath: 'path/to/functions'))
            .called(1);
      });

      test('minimal config', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigStaging'))
            .thenAnswer((_) async => minimalConfigData);
        when(() => mockProvider.initFunctions(
            remotePath: 'path/to/functions',
            localPath: null,
            version: null)).thenAnswer((_) async {});

        final DUIConfig config = await createStagingStrategy().getConfig();

        expect(config, isA<DUIConfig>());
        expect(config.version, isNull,
            reason: 'Optional version should be null');
        expect(config.versionUpdated, isNull,
            reason: 'Optional version update flag should be null');
        expect(config.functionsFilePath, isNull,
            reason: 'Optional functions path should be null');
      });
    });

    group('Error scenarios', () {
      test('network error', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigStaging'))
            .thenThrow(Exception('Network error'));

        expect(
          () => createStagingStrategy().getConfig(),
          throwsA(isA<ConfigException>()
              .having(
                  (e) => e.type, 'error type', equals(ConfigErrorType.network))
              .having((e) => e.message, 'message',
                  contains('Failed to load config'))),
        );
      });

      test('invalid data', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigStaging'))
            .thenAnswer((_) async => invalidConfigData);

        expect(
          () => createStagingStrategy().getConfig(),
          throwsA(isA<ConfigException>()),
        );
      });

      test('null response', () async {
        when(() => mockProvider.getAppConfigFromNetwork(
            '/config/getAppConfigStaging')).thenAnswer((_) async => null);

        expect(
          () => createStagingStrategy().getConfig(),
          throwsA(isA<ConfigException>()
              .having((e) => e.type, 'type', equals(ConfigErrorType.network))),
        );
      });
    });
  });
}
