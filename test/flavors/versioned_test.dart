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

    group('Success scenarios', () {
      test('fetch config with matching version', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigForVersion'))
            .thenAnswer((_) async => {
                  ...validConfigData,
                  'version': 2,
                });
        when(() => mockProvider.initFunctions(
            remotePath: any(named: 'remotePath'))).thenAnswer((_) async {});

        final DUIConfig config = await createVersionedStrategy(2).getConfig();

        expect(config, isA<DUIConfig>());
        expect(config.version, equals(2));
        verify(() => mockProvider.addVersionHeader(2)).called(1);
      });

      test('fetch config with different versions', () async {
        for (final version in [1, 5, 10]) {
          when(() => mockProvider.getAppConfigFromNetwork(
              '/config/getAppConfigForVersion')).thenAnswer((_) async {
            validConfigData['version'] = version;
            return validConfigData;
          });

          final DUIConfig config =
              await createVersionedStrategy(version).getConfig();
          expect(config, isA<DUIConfig>());
          expect(config.version, equals(version));
          verify(() => mockProvider.addVersionHeader(version)).called(1);
        }
      });
    });

    group('Error scenarios', () {
      test('network error', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigForVersion'))
            .thenThrow(Exception('Network error'));

        expect(
          () => createVersionedStrategy(1).getConfig(),
          throwsA(isA<ConfigException>()
              .having((e) => e.type, 'type', equals(ConfigErrorType.network))),
        );
      });

      test('invalid version in response', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigForVersion'))
            .thenAnswer((_) async => {
                  ...validConfigData,
                  'version': 'invalid',
                });

        expect(
          () => createVersionedStrategy(1).getConfig(),
          throwsA(isA<ConfigException>().having(
              (e) => e.type, 'type', equals(ConfigErrorType.invalidData))),
        );
      });

      test('missing version in response', () async {
        when(() => mockProvider.getAppConfigFromNetwork(
            '/config/getAppConfigForVersion')).thenAnswer((_) async {
          validConfigData.remove('version');
          return validConfigData;
        });

        expect(
          () => createVersionedStrategy(1).getConfig(),
          throwsA(isA<ConfigException>().having(
              (e) => e.type, 'type', equals(ConfigErrorType.invalidData))),
        );
      });

      test('function initialization error', () async {
        when(() => mockProvider
                .getAppConfigFromNetwork('/config/getAppConfigForVersion'))
            .thenAnswer((_) async => validConfigData);
        when(() => mockProvider.initFunctions(
            remotePath: 'path/to/functions',
            localPath: null,
            version: null)).thenThrow(ConfigException('Function init failed'));

        expect(
          () => createVersionedStrategy(1).getConfig(),
          throwsA(isA<ConfigException>().having(
              (e) => e.message, 'message', contains('Function init failed'))),
        );
      });
    });
  });
}
