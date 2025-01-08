import 'package:digia_ui/src/config/exception.dart';
import 'package:digia_ui/src/config/factory.dart';
import 'package:digia_ui/src/config/model.dart';
import 'package:digia_ui/src/config/source/base.dart';
import 'package:digia_ui/src/environment.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';
import '../config_data.dart';

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
            remotePath: any(named: 'remotePath'))).thenAnswer((_) async {});

        final config = await createStagingStrategy().getConfig();

        expect(config, isA<DUIConfig>());
        expect(config.version, equals(1));
        verify(() => mockProvider
            .getAppConfigFromNetwork('/config/getAppConfigStaging')).called(1);
      });

      test('minimal config', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigStaging'))
            .thenAnswer((_) async => minimalConfigData);
        when(() => mockProvider.initFunctions(
            remotePath: any(named: 'remotePath'))).thenAnswer((_) async {});

        final config = await createStagingStrategy().getConfig();
        expect(config, isA<DUIConfig>());
        expect(config.version, isNull);
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
              .having((e) => e.type, 'type', equals(ConfigErrorType.network))),
        );
      });

      test('invalid data', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigStaging'))
            .thenAnswer((_) async => invalidConfigData);

        expect(
          () => createStagingStrategy().getConfig(),
          throwsA(isA<ConfigException>().having(
              (e) => e.type, 'type', equals(ConfigErrorType.invalidData))),
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
