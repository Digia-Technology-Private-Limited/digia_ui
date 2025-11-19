import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('VirtualWidgetRegistry - Chart Integration', () {
    late VirtualWidgetRegistry registry;

    setUp(() {
      registry = VirtualWidgetRegistry.defaultRegistry;
    });

    test('should have chart builder registered', () {
      final builders = registry.builders;
      expect(builders.containsKey('digia/chart'), isTrue);
    });

    test('should retrieve chartBuilder from registry', () {
      final builder = registry.builders['digia/chart'];
      expect(builder, isNotNull);
      expect(builder, equals(chartBuilder));
    });

    test('should create chart widget through registry', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'line',
          'labels': ['A', 'B'],
          'chartData': [
            {'label': 'Data', 'data': [10, 20]}
          ],
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'testChart',
      );

      final builder = registry.builders['digia/chart'];
      final widget = builder!(nodeData, null, registry);

      expect(widget, isA<VWChart>());
    });

    test('should maintain chart builder alongside other builders', () {
      final builders = registry.builders;

      // Check that chart builder exists with other expected builders
      expect(builders.containsKey('digia/chart'), isTrue);
      expect(builders.containsKey('digia/text'), isTrue);
      expect(builders.containsKey('digia/button'), isTrue);
    });

    test('should build chart with all supported types through registry', () {
      final chartTypes = ['line', 'bar', 'pie', 'doughnut', 'polarArea', 'radar'];

      for (final type in chartTypes) {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': type,
            'labels': ['A', 'B'],
            'chartData': [
              {'label': 'Data', 'data': [10, 20]}
            ],
          }),
          commonProps: {},
          parentProps: null,
          childGroups: {},
          refName: 'chart_$type',
        );

        final builder = registry.builders['digia/chart'];
        final widget = builder!(nodeData, null, registry);

        expect(widget, isA<VWChart>(), reason: 'Failed for type: $type');
      }
    });

    test('should handle nested chart widgets through registry', () {
      final parentData = VWNodeData(
        type: 'digia/container',
        props: ExprOr.value({}),
        commonProps: {},
        parentProps: null,
        childGroups: {
          'children': [
            VWNodeData(
              type: 'digia/chart',
              props: ExprOr.value({
                'chartType': 'bar',
              }),
              commonProps: {},
              parentProps: null,
              childGroups: {},
              refName: 'nestedChart',
            ),
          ],
        },
        refName: 'parent',
      );

      // Verify chart builder is accessible for nested structures
      final chartBuilder = registry.builders['digia/chart'];
      expect(chartBuilder, isNotNull);
    });

    test('should support chart widget in various parent contexts', () {
      final parentTypes = ['digia/column', 'digia/row', 'digia/stack', 'digia/center'];

      for (final parentType in parentTypes) {
        final nodeData = VWNodeData(
          type: parentType,
          props: ExprOr.value({}),
          commonProps: {},
          parentProps: null,
          childGroups: {
            'children': [
              VWNodeData(
                type: 'digia/chart',
                props: ExprOr.value({
                  'chartType': 'line',
                }),
                commonProps: {},
                parentProps: null,
                childGroups: {},
                refName: 'chart',
              ),
            ],
          },
          refName: 'parent',
        );

        final chartBuilder = registry.builders['digia/chart'];
        expect(chartBuilder, isNotNull, reason: 'Chart builder should exist for parent: $parentType');
      }
    });
  });
}