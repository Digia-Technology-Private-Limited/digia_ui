import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Pubspec Dependencies', () {
    late YamlMap pubspecContent;

    setUpAll(() {
      final file = File('pubspec.yaml');
      final content = file.readAsStringSync();
      pubspecContent = loadYaml(content) as YamlMap;
    });

    test('should have chartjs_flutter dependency', () {
      final dependencies = pubspecContent['dependencies'] as YamlMap;
      expect(dependencies.containsKey('chartjs_flutter'), isTrue,
          reason: 'chartjs_flutter should be present in dependencies');
    });

    test('chartjs_flutter should have correct version', () {
      final dependencies = pubspecContent['dependencies'] as YamlMap;
      final chartjsVersion = dependencies['chartjs_flutter'];
      expect(chartjsVersion, isNotNull);
      expect(chartjsVersion.toString(), contains('1.0.0'));
    });

    test('should have all required dependencies for chart functionality', () {
      final dependencies = pubspecContent['dependencies'] as YamlMap;
      
      // Core Flutter dependencies
      expect(dependencies.containsKey('flutter'), isTrue);
      
      // Chart dependency
      expect(dependencies.containsKey('chartjs_flutter'), isTrue);
    });

    test('should maintain existing dependencies', () {
      final dependencies = pubspecContent['dependencies'] as YamlMap;
      
      // Verify some existing dependencies are still present
      expect(dependencies.containsKey('flutter'), isTrue);
      
      // The new dependency should be added without removing others
      expect(dependencies.keys.length, greaterThan(1));
    });

    test('pubspec should have valid structure', () {
      expect(pubspecContent.containsKey('name'), isTrue);
      expect(pubspecContent.containsKey('description'), isTrue);
      expect(pubspecContent.containsKey('version'), isTrue);
      expect(pubspecContent.containsKey('dependencies'), isTrue);
    });

    test('pubspec should specify environment constraints', () {
      expect(pubspecContent.containsKey('environment'), isTrue);
      final environment = pubspecContent['environment'] as YamlMap;
      expect(environment.containsKey('sdk'), isTrue);
    });
  });
}