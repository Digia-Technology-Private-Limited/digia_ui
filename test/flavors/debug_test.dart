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

  group('Debug Strategy Tests', () {
    ConfigSource createStrategy() =>
        ConfigStrategyFactory.createStrategy(Debug(), mockProvider);

    group('Successful scenarios', () {
      test('complete config with all fields', () async {
        when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .thenAnswer((_) async => validConfigData);
        when(() => mockProvider.initFunctions(
            remotePath: 'path/to/functions',
            localPath: null,
            version: null)).thenAnswer((_) async {});

        final DUIConfig config = await createStrategy().getConfig();

        expect(config, isA<DUIConfig>(),
            reason: 'Config should be parsed successfully');
        expect(config.version, equals(1), reason: 'Version should match');
        expect(config.versionUpdated, isTrue,
            reason: 'Version update flag should match');
        expect(config.initialRoute, equals('homepage'),
            reason: 'Initial route should match');

        verify(() =>
                mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .called(1);
        verify(() =>
                mockProvider.initFunctions(remotePath: 'path/to/functions'))
            .called(1);
      });

      test('minimal config with required fields only', () async {
        when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .thenAnswer((_) async => minimalConfigData);
        when(() => mockProvider.initFunctions(
            remotePath: 'path/to/functions',
            localPath: null,
            version: null)).thenAnswer((_) async {});

        final DUIConfig config = await createStrategy().getConfig();

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

      test('invalid config structure', () async {
        when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .thenAnswer((_) async => invalidConfigData);

        expect(
          () => createStrategy().getConfig(),
          throwsA(isA<ConfigException>()),
        );
      });

      test('function initialization failure', () async {
        when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .thenAnswer((_) async => validConfigData);
        when(() => mockProvider.initFunctions(
                remotePath: 'path/to/functions',
                localPath: null,
                version: null))
            .thenThrow(ConfigException('Functions not initialized'));

        expect(
          () => createStrategy().getConfig(),
          throwsA(isA<ConfigException>()),
        );
      });

      test('null response', () async {
        when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .thenAnswer((_) async => null);

        expect(
          () => createStrategy().getConfig(),
          throwsA(isA<ConfigException>().having(
              (e) => e.type, 'error type', equals(ConfigErrorType.network))),
        );
      });

      test('empty response', () async {
        when(() => mockProvider.getAppConfigFromNetwork('/config/getAppConfig'))
            .thenAnswer((_) async => {});

        expect(
          () => createStrategy().getConfig(),
          throwsA(isA<ConfigException>()),
        );
      });
    });
  });
}
