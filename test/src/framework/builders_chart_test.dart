import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('chartBuilder', () {
    late VirtualWidgetRegistry registry;

    setUp(() {
      registry = VirtualWidgetRegistry.defaultRegistry;
    });

    test('should create VWChart from VWNodeData', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'useDataSource': false,
          'chartType': 'line',
          'labels': ['A', 'B', 'C'],
          'chartData': [
            {
              'label': 'Dataset 1',
              'data': [10, 20, 30],
            }
          ],
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'testChart',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.refName, equals('testChart'));
      expect(widget.props, isA<ChartProps>());
      expect(widget.props.useDataSource, equals(false));
    });

    test('should create VWChart with data source mode', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'useDataSource': true,
          'dataSource': {
            'type': 'bar',
            'data': {
              'labels': ['X', 'Y'],
              'datasets': [
                {'label': 'Data', 'data': [5, 10]}
              ],
            },
          },
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'dataSourceChart',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.props.useDataSource, equals(true));
      expect(widget.props.dataSource, isNotNull);
    });

    test('should create VWChart with minimal props', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({}),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: null,
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.props, isA<ChartProps>());
    });

    test('should create VWChart with parent widget', () {
      final parentWidget = VWText(
        props: const TextProps(text: ExprOr.value('Parent')),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'pie',
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'childChart',
      );

      final widget = chartBuilder(nodeData, parentWidget, registry);

      expect(widget, isA<VWChart>());
      expect(widget.parent, equals(parentWidget));
    });

    test('should create VWChart with child groups', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'bar',
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {
          'children': [
            VWNodeData(
              type: 'digia/text',
              props: ExprOr.value({'text': 'Child'}),
              commonProps: {},
              parentProps: null,
              childGroups: {},
              refName: null,
            ),
          ],
        },
        refName: 'chartWithChildren',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.childGroups, isNotEmpty);
    });

    test('should handle all chart types', () {
      final chartTypes = ['line', 'bar', 'pie', 'doughnut', 'polarArea', 'radar', 'mixed'];

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

        final widget = chartBuilder(nodeData, null, registry);

        expect(widget, isA<VWChart>());
        expect(widget.props.chartType, isNotNull);
      }
    });

    test('should create VWChart with options', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'line',
          'options': {
            'responsive': true,
            'legend': {
              'display': true,
              'position': 'bottom',
            },
            'title': {
              'display': true,
              'text': 'Test Chart',
            },
          },
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'chartWithOptions',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.props.options, isNotNull);
      expect(widget.props.options!['responsive'], equals(true));
    });

    test('should create VWChart with onChanged action', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'bar',
          'onChanged': {
            'actions': [
              {
                'type': 'updateState',
                'payload': {'key': 'value'},
              }
            ],
          },
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'interactiveChart',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.props.onChanged, isNotNull);
    });

    test('should handle expression-based properties', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': {'expr': 'chartTypeVar'},
          'labels': {'expr': 'chartLabelsVar'},
          'chartData': {'expr': 'chartDataVar'},
          'dataSource': {'expr': 'dataSourceVar'},
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'expressionChart',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.props.chartType, isNotNull);
      expect(widget.props.labels, isNotNull);
      expect(widget.props.chartData, isNotNull);
      expect(widget.props.dataSource, isNotNull);
    });

    test('should create VWChart with complex dataset configurations', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'line',
          'labels': ['Jan', 'Feb', 'Mar', 'Apr'],
          'chartData': [
            {
              'label': 'Revenue',
              'data': [100, 200, 150, 300],
              'type': 'line',
              'borderColor': '#FF5733',
              'backgroundColor': '#FF573333',
              'tension': 0.4,
              'fill': true,
            },
            {
              'label': 'Costs',
              'data': [80, 120, 100, 150],
              'type': 'bar',
              'borderColor': '#33FF57',
              'backgroundColor': '#33FF5733',
              'borderWidth': 2,
            },
          ],
        }),
        commonProps: {},
        parentProps: null,
        childGroups: {},
        refName: 'complexChart',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.props.chartData, isNotNull);
    });

    test('should create VWChart with common props', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'pie',
        }),
        commonProps: {
          'id': 'chartWidget123',
          'className': 'custom-chart',
        },
        parentProps: null,
        childGroups: {},
        refName: 'chartWithCommonProps',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.commonProps, isNotEmpty);
    });

    test('should create VWChart with parent props', () {
      final nodeData = VWNodeData(
        type: 'digia/chart',
        props: ExprOr.value({
          'chartType': 'bar',
        }),
        commonProps: {},
        parentProps: {
          'padding': 16.0,
          'alignment': 'center',
        },
        childGroups: {},
        refName: 'chartWithParentProps',
      );

      final widget = chartBuilder(nodeData, null, registry);

      expect(widget, isA<VWChart>());
      expect(widget.parentProps, isNotNull);
    });
  });
}