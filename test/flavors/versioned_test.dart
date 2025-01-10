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

    group('Success scenarios for Versioned Config Strategy', () {
      test('Happy Path: Config with specific version', () async {
        // ARRANGE
        const expectedVersion = 2;
        const expectedConfigPath = '/config/getAppConfigForVersion';

        // Set up mocks
        when(() => mockProvider.getAppConfigFromNetwork(expectedConfigPath))
            .thenAnswer((_) async {
          final versionedConfig = Map<String, dynamic>.from(validConfigData);
          versionedConfig['version'] = expectedVersion;
          return versionedConfig;
        });

        when(() => mockProvider.initFunctions(
              remotePath: any(named: 'remotePath'),
              localPath: null,
              version: null,
            )).thenAnswer((_) async {});

        when(() => mockProvider.addVersionHeader(any()))
            .thenAnswer((_) async {});

        // ACT
        final config =
            await createVersionedStrategy(expectedVersion).getConfig();

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

        // Verify all function calls
        verify(() => mockProvider.getAppConfigFromNetwork(expectedConfigPath))
            .called(1);
        verify(() => mockProvider.addVersionHeader(expectedVersion)).called(1);
        verify(() => mockProvider.initFunctions(
              remotePath: captureAny(named: 'remotePath'),
              localPath: null,
              version: null,
            )).called(1);
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
