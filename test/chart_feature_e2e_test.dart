import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('Chart Feature End-to-End Tests', () {
    late VirtualWidgetRegistry registry;

    setUp(() {
      registry = VirtualWidgetRegistry.defaultRegistry;
    });

    group('Complete workflow: Node Data -> Builder -> Widget', () {
      test('should create line chart from node data', () {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'useDataSource': false,
            'chartType': 'line',
            'labels': ['Jan', 'Feb', 'Mar', 'Apr'],
            'chartData': [
              {
                'label': 'Revenue',
                'data': [100, 150, 200, 175],
                'borderColor': '#4CAF50',
                'tension': 0.4,
              }
            ],
          }),
          commonProps: {},
          parentProps: null,
          childGroups: {},
          refName: 'revenueChart',
        );

        final widget = chartBuilder(nodeData, null, registry);

        expect(widget, isA<VWChart>());
        expect(widget.refName, equals('revenueChart'));
        expect(widget.props.chartType, isNotNull);
        expect(widget.props.useDataSource, equals(false));
      });

      test('should create bar chart with multiple datasets', () {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': 'bar',
            'labels': ['Q1', 'Q2', 'Q3', 'Q4'],
            'chartData': [
              {
                'label': 'Sales',
                'data': [120, 190, 300, 250],
                'backgroundColor': '#FF6384',
              },
              {
                'label': 'Costs',
                'data': [80, 120, 180, 150],
                'backgroundColor': '#36A2EB',
              }
            ],
            'options': {
              'responsive': true,
              'legend': {
                'display': true,
                'position': 'top',
              }
            }
          }),
          commonProps: {},
          parentProps: null,
          childGroups: {},
          refName: 'salesChart',
        );

        final widget = chartBuilder(nodeData, null, registry);

        expect(widget, isA<VWChart>());
        expect(widget.props.options, isNotNull);
      });

      test('should create pie chart from node data', () {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': 'pie',
            'labels': ['Red', 'Blue', 'Yellow', 'Green'],
            'chartData': [
              {
                'label': 'Colors',
                'data': [30, 50, 20, 40],
                'backgroundColor': ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
              }
            ],
          }),
          commonProps: {},
          parentProps: null,
          childGroups: {},
          refName: 'colorChart',
        );

        final widget = chartBuilder(nodeData, null, registry);

        expect(widget, isA<VWChart>());
        expect(widget.props.chartType, isNotNull);
      });

      test('should create mixed chart with line and bar', () {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': 'mixed',
            'labels': ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
            'chartData': [
              {
                'label': 'Target',
                'data': [100, 100, 100, 100],
                'type': 'line',
                'borderColor': '#FF6384',
                'fill': false,
              },
              {
                'label': 'Actual',
                'data': [90, 110, 95, 105],
                'type': 'bar',
                'backgroundColor': '#36A2EB',
              }
            ],
          }),
          commonProps: {},
          parentProps: null,
          childGroups: {},
          refName: 'performanceChart',
        );

        final widget = chartBuilder(nodeData, null, registry);

        expect(widget, isA<VWChart>());
      });

      test('should create chart using data source mode', () {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'useDataSource': true,
            'dataSource': {
              'type': 'doughnut',
              'data': {
                'labels': ['A', 'B', 'C'],
                'datasets': [
                  {
                    'label': 'Dataset',
                    'data': [10, 20, 30],
                    'backgroundColor': ['#FF6384', '#36A2EB', '#FFCE56'],
                  }
                ]
              },
              'options': {
                'responsive': true,
              }
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
    });

    group('Chart configuration scenarios', () {
      test('should handle chart with custom styling', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {
              'label': 'Styled Line',
              'data': [10, 20, 30],
              'borderColor': '#8E44AD',
              'backgroundColor': 'rgba(142, 68, 173, 0.2)',
              'borderWidth': 3,
              'tension': 0.4,
              'fill': true,
              'pointRadius': 5,
              'pointBackgroundColor': '#8E44AD',
            }
          ],
          options: {
            'responsive': true,
            'maintainAspectRatio': false,
            'legend': {
              'display': true,
              'position': 'bottom',
            },
            'title': {
              'display': true,
              'text': 'Styled Chart Example',
            }
          },
        );

        expect(config['type'], equals('line'));
        expect(config['data']['datasets'][0]['borderColor'], equals('#8E44AD'));
        expect(config['options']['legend']['position'], equals('bottom'));
      });

      test('should handle chart with font customization', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'bar',
          labels: ['Product A', 'Product B'],
          datasets: [
            {
              'label': 'Sales',
              'data': [500, 750],
              'labelStyle': {
                'textColor': '#2C3E50',
                'fontToken': {
                  'font': {
                    'fontFamily': 'Roboto',
                    'size': 16,
                    'weight': 'Bold',
                    'isItalic': false,
                    'height': 1.4,
                  }
                }
              }
            }
          ],
          options: {
            'legend': {
              'display': true,
            },
            'title': {
              'display': true,
              'text': 'Product Sales',
              'titleStyle': {
                'textColor': '#34495E',
                'fontToken': {
                  'font': {
                    'fontFamily': 'Arial',
                    'size': 20,
                    'weight': '700',
                    'isItalic': false,
                    'height': 1.5,
                  }
                }
              }
            }
          },
        );

        final legend = config['options']['plugins']['legend'];
        expect(legend['labels']['font']['family'], equals('Roboto'));
        expect(legend['labels']['font']['size'], equals(16));
        expect(legend['labels']['color'], equals('#2C3E50'));

        final title = config['options']['plugins']['title'];
        expect(title['font']['family'], equals('Arial'));
        expect(title['font']['size'], equals(20));
      });

      test('should handle real-world dashboard scenario', () {
        // Simulate a dashboard with multiple metrics
        final salesNodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': 'line',
            'labels': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            'chartData': [
              {
                'label': 'Daily Sales',
                'data': [1200, 1900, 1500, 2100, 1800],
                'borderColor': '#27AE60',
                'tension': 0.4,
              }
            ],
          }),
          commonProps: {'className': 'dashboard-chart'},
          parentProps: null,
          childGroups: {},
          refName: 'dailySales',
        );

        final trafficNodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': 'bar',
            'labels': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
            'chartData': [
              {
                'label': 'Website Traffic',
                'data': [3500, 4200, 3800, 4500, 4100],
                'backgroundColor': '#3498DB',
              }
            ],
          }),
          commonProps: {'className': 'dashboard-chart'},
          parentProps: null,
          childGroups: {},
          refName: 'websiteTraffic',
        );

        final conversionNodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': 'doughnut',
            'labels': ['Converted', 'Not Converted'],
            'chartData': [
              {
                'label': 'Conversion Rate',
                'data': [34, 66],
                'backgroundColor': ['#27AE60', '#E74C3C'],
              }
            ],
          }),
          commonProps: {'className': 'dashboard-chart'},
          parentProps: null,
          childGroups: {},
          refName: 'conversionRate',
        );

        final widgets = [
          chartBuilder(salesNodeData, null, registry),
          chartBuilder(trafficNodeData, null, registry),
          chartBuilder(conversionNodeData, null, registry),
        ];

        for (final widget in widgets) {
          expect(widget, isA<VWChart>());
        }
      });

      test('should handle expression-based dynamic charts', () {
        final nodeData = VWNodeData(
          type: 'digia/chart',
          props: ExprOr.value({
            'chartType': {'expr': 'state.chartType'},
            'labels': {'expr': 'state.chartLabels'},
            'chartData': {'expr': 'state.chartDatasets'},
          }),
          commonProps: {},
          parentProps: null,
          childGroups: {},
          refName: 'dynamicChart',
        );

        final widget = chartBuilder(nodeData, null, registry);

        expect(widget, isA<VWChart>());
        expect(widget.props.chartType, isNotNull);
        expect(widget.props.labels, isNotNull);
        expect(widget.props.chartData, isNotNull);
      });
    });

    group('Performance and edge cases', () {
      test('should handle large datasets efficiently', () {
        final largeDataset = List.generate(1000, (i) => i * 1.5);
        final largeLabels = List.generate(1000, (i) => 'Point $i');

        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: largeLabels,
          datasets: [
            {
              'label': 'Large Dataset',
              'data': largeDataset,
            }
          ],
          options: null,
        );

        expect(config['data']['labels'], hasLength(1000));
        expect(config['data']['datasets'][0]['data'], hasLength(1000));
      });

      test('should handle empty configuration gracefully', () {
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
      });

      test('should handle special characters in labels', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'bar',
          labels: ['<Label>', '"Quoted"', 'Label & More', 'Label\'s'],
          datasets: [
            {
              'label': 'Data & "Special" <Chars>',
              'data': [10, 20, 30, 40],
            }
          ],
          options: null,
        );

        expect(config['data']['labels'], hasLength(4));
      });

      test('should handle various numeric formats', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {
              'label': 'Mixed Numbers',
              'data': [10, 10.5, -5, 0, 1e6, 1e-6],
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['data'], hasLength(6));
      });
    });
  });
}