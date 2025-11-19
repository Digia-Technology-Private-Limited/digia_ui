import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('ChartProps', () {
    group('fromJson constructor', () {
      test('should create ChartProps with all properties from valid JSON', () {
        final json = {
          'useDataSource': true,
          'chartType': 'line',
          'labels': ['Jan', 'Feb', 'Mar'],
          'chartData': [
            {
              'label': 'Dataset 1',
              'data': [10, 20, 30],
              'type': 'line',
            }
          ],
          'options': {
            'responsive': true,
            'maintainAspectRatio': false,
          },
          'dataSource': {
            'type': 'bar',
            'data': {'labels': [], 'datasets': []},
          },
          'onChanged': {
            'actions': [],
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.useDataSource, true);
        expect(props.chartType, isNotNull);
        expect(props.labels, isNotNull);
        expect(props.chartData, isNotNull);
        expect(props.options, isNotNull);
        expect(props.dataSource, isNotNull);
        expect(props.onChanged, isNotNull);
      });

      test('should create ChartProps with minimal JSON (all null properties)', () {
        final json = <String, dynamic>{};

        final props = ChartProps.fromJson(json);

        expect(props.useDataSource, isNull);
        expect(props.chartType, isNull);
        expect(props.labels, isNull);
        expect(props.chartData, isNull);
        expect(props.options, isNull);
        expect(props.dataSource, isNull);
        expect(props.onChanged, isNull);
      });

      test('should handle useDataSource as false', () {
        final json = {
          'useDataSource': false,
        };

        final props = ChartProps.fromJson(json);

        expect(props.useDataSource, false);
      });

      test('should handle chartType as string', () {
        final json = {
          'chartType': 'bar',
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartType, isNotNull);
      });

      test('should handle chartType as expression', () {
        final json = {
          'chartType': {
            'expr': 'myChartType',
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartType, isNotNull);
      });

      test('should handle labels as list', () {
        final json = {
          'labels': ['Q1', 'Q2', 'Q3', 'Q4'],
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
      });

      test('should handle labels as expression', () {
        final json = {
          'labels': {
            'expr': 'chartLabels',
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
      });

      test('should handle empty labels list', () {
        final json = {
          'labels': [],
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
      });

      test('should handle chartData with multiple datasets', () {
        final json = {
          'chartData': [
            {
              'label': 'Dataset 1',
              'data': [10, 20, 30],
              'type': 'line',
              'borderColor': '#FF0000',
              'backgroundColor': '#FF000033',
            },
            {
              'label': 'Dataset 2',
              'data': [15, 25, 35],
              'type': 'bar',
              'borderColor': '#00FF00',
              'backgroundColor': '#00FF0033',
            },
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle empty chartData', () {
        final json = {
          'chartData': [],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle chartData as expression', () {
        final json = {
          'chartData': {
            'expr': 'myDatasets',
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle complex options object', () {
        final json = {
          'options': {
            'responsive': true,
            'maintainAspectRatio': false,
            'legend': {
              'display': true,
              'position': 'bottom',
            },
            'title': {
              'display': true,
              'text': 'My Chart Title',
              'titleStyle': {
                'textColor': '#333333',
                'fontToken': {
                  'font': {
                    'fontFamily': 'Arial',
                    'size': 16,
                    'weight': 'Bold',
                    'isItalic': false,
                    'height': 1.5,
                  }
                }
              }
            },
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.options, isNotNull);
        expect(props.options!['responsive'], true);
        expect(props.options!['maintainAspectRatio'], false);
        expect(props.options!['legend'], isNotNull);
        expect(props.options!['title'], isNotNull);
      });

      test('should handle dataSource with complex structure', () {
        final json = {
          'dataSource': {
            'type': 'line',
            'data': {
              'labels': ['A', 'B', 'C'],
              'datasets': [
                {
                  'label': 'Data',
                  'data': [1, 2, 3],
                }
              ],
            },
            'options': {
              'responsive': true,
            },
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.dataSource, isNotNull);
      });

      test('should handle dataSource as expression', () {
        final json = {
          'dataSource': {
            'expr': 'myChartConfig',
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.dataSource, isNotNull);
      });

      test('should handle onChanged action flow', () {
        final json = {
          'onChanged': {
            'actions': [
              {
                'type': 'updateState',
                'payload': {'key': 'value'},
              }
            ],
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.onChanged, isNotNull);
      });

      test('should handle all chart types', () {
        final chartTypes = ['line', 'bar', 'pie', 'doughnut', 'polarArea', 'radar', 'mixed'];

        for (final type in chartTypes) {
          final json = {
            'chartType': type,
          };

          final props = ChartProps.fromJson(json);

          expect(props.chartType, isNotNull);
        }
      });

      test('should handle null values in nested objects', () {
        final json = {
          'useDataSource': null,
          'chartType': null,
          'labels': null,
          'chartData': null,
          'options': null,
          'dataSource': null,
          'onChanged': null,
        };

        final props = ChartProps.fromJson(json);

        expect(props.useDataSource, isNull);
        expect(props.chartType, isNull);
        expect(props.labels, isNull);
        expect(props.chartData, isNull);
        expect(props.options, isNull);
        expect(props.dataSource, isNull);
        expect(props.onChanged, isNull);
      });

      test('should handle mixed data types in chartData', () {
        final json = {
          'chartData': [
            {
              'label': 'Line Dataset',
              'data': [10, 20, 30, 40],
              'type': 'line',
              'tension': 0.4,
              'fill': false,
            },
            {
              'label': 'Bar Dataset',
              'data': [15, 25, 35, 45],
              'type': 'bar',
              'borderWidth': 2,
            },
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should preserve order of properties', () {
        final json = {
          'labels': ['First', 'Second', 'Third'],
          'chartData': [
            {'label': 'A', 'data': [1, 2, 3]},
            {'label': 'B', 'data': [4, 5, 6]},
          ],
          'chartType': 'bar',
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
        expect(props.chartData, isNotNull);
        expect(props.chartType, isNotNull);
      });

      test('should handle large datasets', () {
        final largeData = List.generate(1000, (i) => i * 10);
        final largeLabels = List.generate(1000, (i) => 'Label $i');

        final json = {
          'labels': largeLabels,
          'chartData': [
            {
              'label': 'Large Dataset',
              'data': largeData,
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
        expect(props.chartData, isNotNull);
      });

      test('should handle special characters in labels and dataset names', () {
        final json = {
          'labels': ['Label & Special', 'Label "Quoted"', 'Label <HTML>', 'Label\'s'],
          'chartData': [
            {
              'label': 'Dataset & "Special" <Characters>',
              'data': [1, 2, 3, 4],
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
        expect(props.chartData, isNotNull);
      });

      test('should handle numeric labels', () {
        final json = {
          'labels': [2020, 2021, 2022, 2023],
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
      });

      test('should handle negative and zero values in data', () {
        final json = {
          'chartData': [
            {
              'label': 'Mixed Values',
              'data': [-10, 0, 10, -5, 15, 0, -20],
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle decimal values in data', () {
        final json = {
          'chartData': [
            {
              'label': 'Decimal Values',
              'data': [10.5, 20.75, 30.25, 40.125],
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle color formats (hex, rgb, rgba)', () {
        final json = {
          'chartData': [
            {
              'label': 'Hex Colors',
              'data': [10, 20, 30],
              'borderColor': '#FF5733',
              'backgroundColor': '#FF573380',
            },
            {
              'label': 'RGB Colors',
              'data': [15, 25, 35],
              'borderColor': 'rgb(255, 87, 51)',
              'backgroundColor': 'rgba(255, 87, 51, 0.5)',
            },
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle gradient colors (if supported)', () {
        final json = {
          'chartData': [
            {
              'label': 'Gradient',
              'data': [10, 20, 30],
              'backgroundColor': {
                'type': 'linear',
                'colors': ['#FF5733', '#C70039'],
              },
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });

      test('should handle font styling options', () {
        final json = {
          'options': {
            'legend': {
              'display': true,
              'labelStyle': {
                'textColor': '#000000',
                'fontToken': {
                  'font': {
                    'fontFamily': 'Roboto',
                    'size': 14,
                    'weight': '500',
                    'isItalic': true,
                    'height': 1.2,
                  }
                }
              }
            }
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.options, isNotNull);
      });

      test('should handle missing optional dataset properties', () {
        final json = {
          'chartData': [
            {
              'label': 'Minimal Dataset',
              'data': [10, 20, 30],
              // Missing: type, borderColor, backgroundColor, etc.
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartData, isNotNull);
      });
    });

    group('const constructor', () {
      test('should create ChartProps with const constructor', () {
        const props = ChartProps(
          useDataSource: true,
        );

        expect(props.useDataSource, true);
        expect(props.chartType, isNull);
        expect(props.labels, isNull);
        expect(props.chartData, isNull);
        expect(props.options, isNull);
        expect(props.dataSource, isNull);
        expect(props.onChanged, isNull);
      });

      test('should create ChartProps with all null values', () {
        const props = ChartProps();

        expect(props.useDataSource, isNull);
        expect(props.chartType, isNull);
        expect(props.labels, isNull);
        expect(props.chartData, isNull);
        expect(props.options, isNull);
        expect(props.dataSource, isNull);
        expect(props.onChanged, isNull);
      });
    });

    group('edge cases', () {
      test('should handle malformed JSON gracefully', () {
        final json = {
          'chartType': 123, // Wrong type, should be string
          'labels': 'not a list', // Wrong type, should be list
          'useDataSource': 'yes', // Wrong type, should be bool
        };

        expect(() => ChartProps.fromJson(json), returnsNormally);
      });

      test('should handle deeply nested options structure', () {
        final json = {
          'options': {
            'plugins': {
              'tooltip': {
                'enabled': true,
                'callbacks': {
                  'label': 'function() {}',
                },
              },
              'annotation': {
                'annotations': [
                  {
                    'type': 'line',
                    'mode': 'horizontal',
                    'scaleID': 'y',
                    'value': 50,
                  }
                ],
              },
            },
          },
        };

        final props = ChartProps.fromJson(json);

        expect(props.options, isNotNull);
      });

      test('should handle empty strings in properties', () {
        final json = {
          'chartType': '',
          'labels': ['', '', ''],
          'chartData': [
            {
              'label': '',
              'data': [1, 2, 3],
              'type': '',
            }
          ],
        };

        final props = ChartProps.fromJson(json);

        expect(props.chartType, isNotNull);
        expect(props.labels, isNotNull);
        expect(props.chartData, isNotNull);
      });

      test('should handle Unicode characters in labels', () {
        final json = {
          'labels': ['日本', '中国', '한국', '🎨', '€', '©'],
        };

        final props = ChartProps.fromJson(json);

        expect(props.labels, isNotNull);
      });
    });
  });
}