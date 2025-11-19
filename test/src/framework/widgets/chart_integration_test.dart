import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('Chart Integration Tests', () {
    testWidgets('should render error widget when useDataSource is true but dataSource is null',
        (WidgetTester tester) async {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: true,
          dataSource: null,
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      // Create a minimal RenderPayload for testing
      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: chart.render(payload),
          ),
        ),
      );

      expect(find.text('Invalid Chart Configuration'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('should render error widget when chartData is empty in properties mode',
        (WidgetTester tester) async {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          chartType: ExprOr.value('line'),
          labels: ExprOr.value(['A', 'B']),
          chartData: ExprOr.value([]),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: chart.render(payload),
          ),
        ),
      );

      expect(find.text('No chart data provided.'), findsOneWidget);
    });

    testWidgets('should render SizedBox with correct dimensions',
        (WidgetTester tester) async {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          chartType: ExprOr.value('line'),
          labels: ExprOr.value(['A', 'B']),
          chartData: ExprOr.value([
            {
              'label': 'Data',
              'data': [10, 20],
            }
          ]),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: chart.render(payload),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(400));
      expect(sizedBox.height, equals(300));
    });

    test('should evaluate expressions in chartType', () {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          chartType: ExprOr.expr('myChartType'),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {'myChartType': 'bar'}),
        theme: ThemeData(),
      );

      // The render method should evaluate the expression
      expect(() => chart.render(payload), returnsNormally);
    });

    test('should evaluate expressions in labels', () {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          labels: ExprOr.expr('myLabels'),
          chartType: ExprOr.value('line'),
          chartData: ExprOr.value([
            {'label': 'Data', 'data': [10, 20]}
          ]),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {
          'myLabels': ['X', 'Y']
        }),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });

    test('should evaluate expressions in dataSource', () {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: true,
          dataSource: ExprOr.expr('myChartConfig'),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {
          'myChartConfig': {
            'type': 'line',
            'data': {
              'labels': ['A', 'B'],
              'datasets': [
                {'label': 'Data', 'data': [10, 20]}
              ]
            }
          }
        }),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });

    test('should default chartType to line when not specified', () {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          chartData: ExprOr.value([
            {'label': 'Data', 'data': [10, 20]}
          ]),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });

    test('should handle multiple datasets in properties mode', () {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          chartType: ExprOr.value('line'),
          labels: ExprOr.value(['A', 'B', 'C']),
          chartData: ExprOr.value([
            {'label': 'Dataset 1', 'data': [10, 20, 30], 'type': 'line'},
            {'label': 'Dataset 2', 'data': [15, 25, 35], 'type': 'bar'},
          ]),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });

    test('should handle options with legend configuration', () {
      final chart = VWChart(
        props: ChartProps(
          useDataSource: false,
          chartType: const ExprOr.value('bar'),
          labels: const ExprOr.value(['A', 'B']),
          chartData: const ExprOr.value([
            {'label': 'Data', 'data': [10, 20]}
          ]),
          options: {
            'legend': {
              'display': true,
              'position': 'bottom',
            }
          },
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });

    test('should handle options with title configuration', () {
      final chart = VWChart(
        props: ChartProps(
          useDataSource: false,
          chartType: const ExprOr.value('pie'),
          labels: const ExprOr.value(['A', 'B', 'C']),
          chartData: const ExprOr.value([
            {'label': 'Data', 'data': [10, 20, 30]}
          ]),
          options: {
            'title': {
              'display': true,
              'text': 'My Pie Chart',
            }
          },
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });

    test('should handle chart with styling properties', () {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: false,
          chartType: ExprOr.value('line'),
          labels: ExprOr.value(['A', 'B']),
          chartData: ExprOr.value([
            {
              'label': 'Styled Data',
              'data': [10, 20],
              'borderColor': '#FF5733',
              'backgroundColor': '#FF573333',
              'borderWidth': 3,
              'tension': 0.4,
              'fill': true,
            }
          ]),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      expect(() => chart.render(payload), returnsNormally);
    });
  });

  group('Chart Error Handling', () {
    testWidgets('should show error for wrong dataSource type',
        (WidgetTester tester) async {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: true,
          dataSource: ExprOr.value('invalid string'),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: chart.render(payload),
          ),
        ),
      );

      expect(find.text('Invalid Chart Configuration'), findsOneWidget);
    });

    testWidgets('should show error for null evaluated dataSource',
        (WidgetTester tester) async {
      final chart = VWChart(
        props: const ChartProps(
          useDataSource: true,
          dataSource: ExprOr.expr('nonExistentVar'),
        ),
        commonProps: {},
        parent: null,
        childGroups: const {},
      );

      final payload = RenderPayload(
        scopeContext: ScopeContext(data: {}),
        theme: ThemeData(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: chart.render(payload),
          ),
        ),
      );

      expect(find.text('Invalid Chart Configuration'), findsOneWidget);
    });
  });

  group('ChartConfigBuilder Font Options', () {
    test('should build font options from style map', () {
      final fontOptions = ChartConfigBuilder._buildFontOptions({
        'fontToken': {
          'font': {
            'fontFamily': 'Arial',
            'size': 14,
            'weight': 'Bold',
            'isItalic': true,
            'height': 1.5,
          }
        }
      });

      expect(fontOptions['family'], equals('Arial'));
      expect(fontOptions['size'], equals(14));
      expect(fontOptions['weight'], equals('bold'));
      expect(fontOptions['style'], equals('italic'));
      expect(fontOptions['lineHeight'], equals(1.5));
    });

    test('should handle numeric font weight', () {
      final fontOptions = ChartConfigBuilder._buildFontOptions({
        'fontToken': {
          'font': {
            'weight': '600',
          }
        }
      });

      expect(fontOptions['weight'], equals(600));
    });

    test('should handle Normal weight string', () {
      final fontOptions = ChartConfigBuilder._buildFontOptions({
        'fontToken': {
          'font': {
            'weight': 'Normal',
          }
        }
      });

      expect(fontOptions['weight'], equals('normal'));
    });

    test('should handle false isItalic', () {
      final fontOptions = ChartConfigBuilder._buildFontOptions({
        'fontToken': {
          'font': {
            'isItalic': false,
          }
        }
      });

      expect(fontOptions['style'], equals('normal'));
    });

    test('should return empty map for null style', () {
      final fontOptions = ChartConfigBuilder._buildFontOptions(null);
      expect(fontOptions, isEmpty);
    });

    test('should handle missing font properties', () {
      final fontOptions = ChartConfigBuilder._buildFontOptions({
        'fontToken': {
          'font': {}
        }
      });

      expect(fontOptions, isNotEmpty);
    });
  });
}