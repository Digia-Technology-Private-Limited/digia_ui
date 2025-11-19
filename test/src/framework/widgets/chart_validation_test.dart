import 'package:flutter_test/flutter_test.dart';
import 'package:digia_ui/digia_ui.dart';

void main() {
  group('Chart Validation', () {
    group('_validateChartTypes', () {
      test('should return null for valid cartesian charts (line + bar)', () {
        final chart = VWChart(
          props: const ChartProps(),
          commonProps: {},
          parent: null,
          childGroups: const {},
        );

        final datasets = [
          {'type': 'line', 'label': 'Line', 'data': [1, 2, 3]},
          {'type': 'bar', 'label': 'Bar', 'data': [4, 5, 6]},
        ];

        // Access private method through reflection or testing approach
        // Since _validateChartTypes is private, we test via render behavior
        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'mixed',
            labels: ['A', 'B', 'C'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should return null for single chart type', () {
        final datasets = [
          {'type': 'line', 'label': 'Line 1', 'data': [1, 2, 3]},
          {'type': 'line', 'label': 'Line 2', 'data': [4, 5, 6]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'line',
            labels: ['A', 'B', 'C'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should return null for empty datasets', () {
        final datasets = <Map<String, dynamic>>[];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'line',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should return null for datasets without type specified', () {
        final datasets = [
          {'label': 'Data 1', 'data': [1, 2, 3]},
          {'label': 'Data 2', 'data': [4, 5, 6]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'line',
            labels: ['A', 'B', 'C'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should allow all line charts', () {
        final datasets = [
          {'type': 'line', 'label': 'Line 1', 'data': [1, 2]},
          {'type': 'line', 'label': 'Line 2', 'data': [3, 4]},
          {'type': 'line', 'label': 'Line 3', 'data': [5, 6]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'line',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should allow all bar charts', () {
        final datasets = [
          {'type': 'bar', 'label': 'Bar 1', 'data': [1, 2]},
          {'type': 'bar', 'label': 'Bar 2', 'data': [3, 4]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'bar',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should allow single pie chart', () {
        final datasets = [
          {'type': 'pie', 'label': 'Pie', 'data': [1, 2, 3]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'pie',
            labels: ['A', 'B', 'C'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should allow single doughnut chart', () {
        final datasets = [
          {'type': 'doughnut', 'label': 'Doughnut', 'data': [10, 20]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'doughnut',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should allow single polarArea chart', () {
        final datasets = [
          {'type': 'polarArea', 'label': 'Polar', 'data': [5, 10, 15]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'polarArea',
            labels: ['A', 'B', 'C'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should allow single radar chart', () {
        final datasets = [
          {'type': 'radar', 'label': 'Radar', 'data': [1, 2, 3, 4]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'radar',
            labels: ['A', 'B', 'C', 'D'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });
    });

    group('Chart type compatibility', () {
      test('should handle mixed line and bar correctly', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [
            {'type': 'line', 'label': 'Line', 'data': [10, 20]},
            {'type': 'bar', 'label': 'Bar', 'data': [15, 25]},
          ],
          options: null,
        );

        // Should use 'bar' as base type for mixed cartesian
        expect(config['type'], equals('bar'));
        expect(config['data']['datasets'], hasLength(2));
      });

      test('should detect mixed chart automatically', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line', // Even if specified as line
          labels: ['A', 'B'],
          datasets: [
            {'type': 'line', 'label': 'Line', 'data': [10, 20]},
            {'type': 'bar', 'label': 'Bar', 'data': [15, 25]},
          ],
          options: null,
        );

        expect(config['type'], equals('bar'));
      });

      test('should not change type for uniform datasets', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: [
            {'type': 'line', 'label': 'Line 1', 'data': [10, 20]},
            {'type': 'line', 'label': 'Line 2', 'data': [15, 25]},
          ],
          options: null,
        );

        expect(config['type'], equals('line'));
      });

      test('should handle explicit mixed type', () {
        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'mixed',
          labels: ['A', 'B'],
          datasets: [
            {'type': 'line', 'label': 'Line', 'data': [10, 20]},
          ],
          options: null,
        );

        expect(config['type'], equals('bar'));
      });
    });

    group('Edge cases', () {
      test('should handle datasets with null type', () {
        final datasets = [
          {'type': null, 'label': 'Data', 'data': [10, 20]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'line',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should handle datasets with missing type', () {
        final datasets = [
          {'label': 'Data', 'data': [10, 20]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'bar',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });

      test('should handle datasets with empty string type', () {
        final datasets = [
          {'type': '', 'label': 'Data', 'data': [10, 20]},
        ];

        final config = ChartConfigBuilder.buildChartConfig(
          chartType: 'line',
          labels: ['A', 'B'],
          datasets: datasets,
          options: null,
        );

        expect(config['type'], equals('line'));
      });

      test('should handle case-sensitive type names', () {
        final datasets = [
          {'type': 'Line', 'label': 'Data', 'data': [10, 20]},
        ];

        expect(
          () => ChartConfigBuilder.buildChartConfig(
            chartType: 'line',
            labels: ['A', 'B'],
            datasets: datasets,
            options: null,
          ),
          returnsNormally,
        );
      });
    });
  });
}