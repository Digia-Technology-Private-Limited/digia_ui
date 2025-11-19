import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('VWChart', () {
    late ChartProps testProps;
    late Map<String, dynamic> testCommonProps;

    setUp(() {
      testProps = const ChartProps(
        useDataSource: false,
      );
      testCommonProps = {};
    });

    group('constructor', () {
      test('should create VWChart with required parameters', () {
        final chart = VWChart(
          props: testProps,
          commonProps: testCommonProps,
          parent: null,
          childGroups: const {},
        );

        expect(chart, isNotNull);
        expect(chart.props, equals(testProps));
      });

      test('should create VWChart with all parameters', () {
        final chart = VWChart(
          props: testProps,
          commonProps: testCommonProps,
          parentProps: {},
          parent: null,
          refName: 'testChart',
          childGroups: const {},
        );

        expect(chart, isNotNull);
        expect(chart.refName, equals('testChart'));
      });
    });

    group('ChartConfigBuilder.buildChartConfig', () {
      test('should build basic line chart config', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['Jan', 'Feb', 'Mar'],
          datasets: [
            {
              'label': 'Dataset 1',
              'data': [10, 20, 30],
            }
          ],
          options: null,
        );

        expect(config['type'], equals('line'));
        expect(config['data']['labels'], equals(['Jan', 'Feb', 'Mar']));
        expect(config['data']['datasets'], hasLength(1));
        expect(config['options'], isNotNull);
      });

      test('should build bar chart config', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'bar',
          labels: ['Q1', 'Q2', 'Q3', 'Q4'],
          datasets: [
            {
              'label': 'Sales',
              'data': [100, 200, 150, 300],
              'backgroundColor': '#FF5733',
            }
          ],
          options: null,
        );

        expect(config['type'], equals('bar'));
        expect(config['data']['labels'], hasLength(4));
        expect(config['data']['datasets'][0]['backgroundColor'], equals('#FF5733'));
      });

      test('should build pie chart config', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'pie',
          labels: ['Red', 'Blue', 'Yellow'],
          datasets: [
            {
              'label': 'Colors',
              'data': [30, 50, 20],
              'backgroundColor': ['#FF0000', '#0000FF', '#FFFF00'],
            }
          ],
          options: null,
        );

        expect(config['type'], equals('pie'));
        expect(config['data']['datasets'][0]['backgroundColor'], hasLength(3));
      });

      test('should detect mixed chart and use bar as base type', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {
              'label': 'Line Data',
              'data': [10, 20, 30],
              'type': 'line',
            },
            {
              'label': 'Bar Data',
              'data': [15, 25, 35],
              'type': 'bar',
            }
          ],
          options: null,
        );

        expect(config['type'], equals('bar'));
        expect(config['data']['datasets'][0]['type'], equals('line'));
        expect(config['data']['datasets'][1]['type'], equals('bar'));
      });

      test('should handle mixed chart type explicitly', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'mixed',
          labels: ['X', 'Y', 'Z'],
          datasets: [
            {
              'label': 'Dataset A',
              'data': [1, 2, 3],
              'type': 'line',
            }
          ],
          options: null,
        );

        expect(config['type'], equals('bar'));
      });

      test('should convert labels to strings', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: [2020, 2021, 2022],
          datasets: [
            {
              'label': 'Years',
              'data': [100, 200, 300],
            }
          ],
          options: null,
        );

        expect(config['data']['labels'], equals(['2020', '2021', '2022']));
      });

      test('should handle empty labels', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: [],
          datasets: [
            {
              'label': 'Data',
              'data': [10, 20, 30],
            }
          ],
          options: null,
        );

        expect(config['data']['labels'], isEmpty);
      });

      test('should handle null labels', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: null,
          datasets: [
            {
              'label': 'Data',
              'data': [10, 20, 30],
            }
          ],
          options: null,
        );

        expect(config['data']['labels'], isEmpty);
      });

      test('should clean datasets by removing null/empty values', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [
            {
              'label': 'Test',
              'data': [10, 20],
              'borderColor': '#FF0000',
              'backgroundColor': null,
              'borderWidth': '',
              'tension': 0.4,
            }
          ],
          options: null,
        );

        final dataset = config['data']['datasets'][0];
        expect(dataset['borderColor'], equals('#FF0000'));
        expect(dataset.containsKey('backgroundColor'), isFalse);
        expect(dataset.containsKey('borderWidth'), isFalse);
        expect(dataset['tension'], equals(0.4));
      });

      test('should preserve dataset type in mixed charts', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {
              'label': 'Dataset 1',
              'data': [10, 20, 30],
              'type': 'line',
            },
            {
              'label': 'Dataset 2',
              'data': [15, 25, 35],
              'type': 'bar',
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['type'], equals('line'));
        expect(config['data']['datasets'][1]['type'], equals('bar'));
      });

      test('should not include type for non-mixed charts', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [
            {
              'label': 'Data',
              'data': [10, 20],
            }
          ],
          options: null,
        );

        final dataset = config['data']['datasets'][0];
        expect(dataset.containsKey('type'), isFalse);
      });

      test('should handle multiple datasets', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {'label': 'D1', 'data': [10, 20, 30]},
            {'label': 'D2', 'data': [15, 25, 35]},
            {'label': 'D3', 'data': [5, 15, 25]},
          ],
          options: null,
        );

        expect(config['data']['datasets'], hasLength(3));
      });

      test('should handle empty datasets list', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [],
          options: null,
        );

        expect(config['data']['datasets'], isEmpty);
      });

      test('should convert numeric data to correct type', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [
            {
              'label': 'Numbers',
              'data': [10, 20.5, 30],
            }
          ],
          options: null,
        );

        final data = config['data']['datasets'][0]['data'];
        expect(data, equals([10, 20.5, 30]));
      });

      test('should provide default options when null', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {'label': 'D', 'data': [10]}
          ],
          options: null,
        );

        expect(config['options']['responsive'], equals(true));
        expect(config['options']['maintainAspectRatio'], equals(false));
        expect(config['options']['plugins']['legend']['display'], equals(true));
        expect(config['options']['plugins']['legend']['position'], equals('top'));
      });

      test('should merge custom options with defaults', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {'label': 'D', 'data': [10]}
          ],
          options: {
            'responsive': false,
            'legend': {
              'display': false,
              'position': 'bottom',
            },
          },
        );

        expect(config['options']['responsive'], equals(false));
        expect(config['options']['plugins']['legend']['display'], equals(false));
        expect(config['options']['plugins']['legend']['position'], equals('bottom'));
      });

      test('should build legend options with font styles', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'D',
              'data': [10],
              'labelStyle': {
                'textColor': '#FF0000',
                'fontToken': {
                  'font': {
                    'fontFamily': 'Arial',
                    'size': 14,
                    'weight': 'Bold',
                    'isItalic': true,
                    'height': 1.5,
                  }
                }
              }
            }
          ],
          options: {
            'legend': {
              'display': true,
              'position': 'right',
            }
          },
        );

        final legend = config['options']['plugins']['legend'];
        expect(legend['display'], equals(true));
        expect(legend['position'], equals('right'));
        expect(legend['labels']['font']['family'], equals('Arial'));
        expect(legend['labels']['font']['size'], equals(14));
        expect(legend['labels']['font']['weight'], equals('bold'));
        expect(legend['labels']['font']['style'], equals('italic'));
        expect(legend['labels']['color'], equals('#FF0000'));
      });

      test('should build title options with font styles', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {'label': 'D', 'data': [10]}
          ],
          options: {
            'title': {
              'display': true,
              'text': 'My Chart',
              'titleStyle': {
                'textColor': '#000000',
                'fontToken': {
                  'font': {
                    'fontFamily': 'Helvetica',
                    'size': 18,
                    'weight': '600',
                    'isItalic': false,
                    'height': 1.2,
                  }
                }
              }
            }
          },
        );

        final title = config['options']['plugins']['title'];
        expect(title['display'], equals(true));
        expect(title['text'], equals('My Chart'));
        expect(title['font']['family'], equals('Helvetica'));
        expect(title['font']['size'], equals(18));
        expect(title['font']['weight'], equals(600));
        expect(title['font']['style'], equals('normal'));
        expect(title['color'], equals('#000000'));
      });

      test('should handle font weight as string', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'D',
              'data': [10],
              'labelStyle': {
                'fontToken': {
                  'font': {
                    'weight': 'Normal',
                  }
                }
              }
            }
          ],
          options: {
            'legend': {'display': true}
          },
        );

        expect(config['options']['plugins']['legend']['labels']['font']['weight'], equals('normal'));
      });

      test('should handle font weight as numeric string', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'D',
              'data': [10],
              'labelStyle': {
                'fontToken': {
                  'font': {
                    'weight': '700',
                  }
                }
              }
            }
          ],
          options: {
            'legend': {'display': true}
          },
        );

        expect(config['options']['plugins']['legend']['labels']['font']['weight'], equals(700));
      });

      test('should handle italic font correctly', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'D',
              'data': [10],
              'labelStyle': {
                'fontToken': {
                  'font': {
                    'isItalic': true,
                  }
                }
              }
            }
          ],
          options: {
            'legend': {'display': true}
          },
        );

        expect(config['options']['plugins']['legend']['labels']['font']['style'], equals('italic'));
      });

      test('should handle non-italic font correctly', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'D',
              'data': [10],
              'labelStyle': {
                'fontToken': {
                  'font': {
                    'isItalic': false,
                  }
                }
              }
            }
          ],
          options: {
            'legend': {'display': true}
          },
        );

        expect(config['options']['plugins']['legend']['labels']['font']['style'], equals('normal'));
      });

      test('should handle missing font properties gracefully', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'D',
              'data': [10],
              'labelStyle': {
                'fontToken': {
                  'font': {}
                }
              }
            }
          ],
          options: {
            'legend': {'display': true}
          },
        );

        expect(config['options']['plugins']['legend']['labels']['font'], isNotNull);
      });
    });

    group('ChartConfigBuilder edge cases', () {
      test('should handle datasets with optional properties', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [
            {
              'label': 'Dataset',
              'data': [10, 20],
              'borderColor': '#FF0000',
              'backgroundColor': '#FF000033',
              'borderWidth': 2,
              'tension': 0.4,
              'fill': true,
            }
          ],
          options: null,
        );

        final dataset = config['data']['datasets'][0];
        expect(dataset['borderColor'], equals('#FF0000'));
        expect(dataset['backgroundColor'], equals('#FF000033'));
        expect(dataset['borderWidth'], equals(2));
        expect(dataset['tension'], equals(0.4));
        expect(dataset['fill'], equals(true));
      });

      test('should handle empty string in dataset properties', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': '',
              'data': [10],
              'borderColor': '',
            }
          ],
          options: null,
        );

        final dataset = config['data']['datasets'][0];
        expect(dataset['label'], equals(''));
        expect(dataset.containsKey('borderColor'), isFalse);
      });

      test('should handle very large data values', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'Large',
              'data': [1e10, 1e15, 1e20],
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['data'], hasLength(3));
      });

      test('should handle very small data values', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A'],
          datasets: [
            {
              'label': 'Small',
              'data': [1e-10, 1e-15, 1e-20],
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['data'], hasLength(3));
      });

      test('should handle negative data values', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {
              'label': 'Negative',
              'data': [-10, -20, -30],
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['data'], equals([-10, -20, -30]));
      });

      test('should handle mixed positive and negative values', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'bar',
          labels: ['A', 'B', 'C', 'D'],
          datasets: [
            {
              'label': 'Mixed',
              'data': [10, -20, 30, -40],
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['data'], equals([10, -20, 30, -40]));
      });

      test('should handle zero values', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B', 'C'],
          datasets: [
            {
              'label': 'Zeros',
              'data': [0, 0, 0],
            }
          ],
          options: null,
        );

        expect(config['data']['datasets'][0]['data'], equals([0, 0, 0]));
      });

      test('should handle special chart types', () {
        final types = ['doughnut', 'polarArea', 'radar'];

        for (final type in types) {
          final config = ChartConfigBuilder.buildChartConfig(
            chartType: type,
            labels: ['A', 'B'],
            datasets: [
              {'label': 'Data', 'data': [10, 20]}
            ],
            options: null,
          );

          expect(config['type'], equals(type));
        }
      });
    });
  });
}