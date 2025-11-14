import 'package:chartjs_flutter/chartjs_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/chart_props.dart';

class VWChart extends VirtualStatelessWidget<ChartProps> {
  VWChart(
      {required super.props,
      required super.commonProps,
      super.parentProps,
      required super.parent,
      super.refName,
      required super.childGroups});

  @override
  Widget render(RenderPayload payload) {
    // Evaluate ExprOr values using payload.evalExpr (same as rich_text.dart)
    final chartType = payload.evalExpr(props.chartType) ?? 'line';
    final labels = payload.evalExpr(props.labels);
    final chartDatasets =
        props.chartData?.deepEvaluate(payload.scopeContext) ?? [];
    final options = props.options;

    // Return placeholder if no chart data is provided
    if (chartDatasets == null ||
        chartDatasets is! List ||
        chartDatasets.isEmpty) {
      return const SizedBox(
        width: 400,
        height: 300,
        child: Center(child: Text('No chart data provided.')),
      );
    }

    // Validate chart type compatibility
    final validationError =
        _validateChartTypes(chartDatasets.cast<Map<String, dynamic>>());
    if (validationError != null) {
      return SizedBox(
        width: 400,
        height: 300,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Color(0xFFD32F2F),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Invalid Chart Configuration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  validationError,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Convert flat structure to Chart.js format
    final chartConfig = ChartConfigBuilder.buildChartConfig(
      chartType: chartType,
      labels: labels,
      datasets: chartDatasets.cast<Map<String, dynamic>>(),
      options: options,
    );

    return SizedBox(
      width: 400,
      height: 300,
      child: ChartJsWidget(
        chartConfig: chartConfig,
      ),
    );
  }

  /// Validates that chart types are compatible
  /// Returns error message if invalid, null if valid
  String? _validateChartTypes(List<Map<String, dynamic>> datasets) {
    if (datasets.isEmpty) return null;

    // Define chart type categories
    final radialTypes = {'pie', 'doughnut', 'polarArea', 'radar'};
    final cartesianTypes = {'line', 'bar'};

    // Collect all dataset types
    final datasetTypes = datasets
        .map((ds) => ds['type'] as String?)
        .where((type) => type != null)
        .cast<String>()
        .toSet();

    // Check if we have both radial and cartesian types
    final hasRadial = datasetTypes.any((type) => radialTypes.contains(type));
    final hasCartesian =
        datasetTypes.any((type) => cartesianTypes.contains(type));

    if (hasRadial && hasCartesian) {
      // Find which specific types are being mixed
      final radialFound =
          datasetTypes.where((type) => radialTypes.contains(type)).toList();
      final cartesianFound =
          datasetTypes.where((type) => cartesianTypes.contains(type)).toList();

      return 'Cannot mix radial charts (${radialFound.join(', ')}) with cartesian charts (${cartesianFound.join(', ')}).\n\n'
          'Please use either:\n'
          '• Only radial charts (pie, doughnut, polarArea, radar)\n'
          '• Only cartesian charts (line, bar)';
    }

    // Check if mixing different radial types (also not recommended)
    if (hasRadial && datasetTypes.length > 1) {
      final allRadial =
          datasetTypes.every((type) => radialTypes.contains(type));
      if (allRadial) {
        final uniqueRadialTypes =
            datasetTypes.where((type) => radialTypes.contains(type)).toSet();
        if (uniqueRadialTypes.length > 1) {
          return 'Cannot mix different radial chart types (${uniqueRadialTypes.join(', ')}).\n\n'
              'Please use datasets of the same type.';
        }
      }
    }

    return null; // Valid configuration
  }
}

class ChartConfigBuilder {
  /// Builds Chart.js config from flat structure
  static Map<String, dynamic> buildChartConfig({
    required String chartType,
    required dynamic labels,
    required List<Map<String, dynamic>> datasets,
    required Map<String, dynamic>? options,
  }) {
    print('🔧 [ChartConfigBuilder] chartType: $chartType');
    print('🔧 [ChartConfigBuilder] labels: $labels');
    print('🔧 [ChartConfigBuilder] datasets count: ${datasets.length}');
    print('🔧 [ChartConfigBuilder] options: $options');

    // Determine if this is a mixed chart
    final isMixed = chartType == 'mixed' || _hasMixedTypes(datasets);
    final effectiveType = isMixed ? 'bar' : chartType;

    print(
        '🔧 [ChartConfigBuilder] isMixed: $isMixed, effectiveType: $effectiveType');

    // Convert labels to List<String>
    final labelsList =
        labels is List ? labels.map((e) => e.toString()).toList() : <String>[];

    print('🔧 [ChartConfigBuilder] labelsList: $labelsList');

    final cleanedDatasets =
        datasets.map((dataset) => _cleanDataset(dataset)).toList();
    print('🔧 [ChartConfigBuilder] cleanedDatasets: $cleanedDatasets');

    return {
      'type': effectiveType,
      'data': {
        'labels': labelsList,
        'datasets': cleanedDatasets,
      },
      'options': _buildOptions(options),
    };
  }

  /// Check if datasets have different types (mixed chart)
  static bool _hasMixedTypes(List<Map<String, dynamic>> datasets) {
    if (datasets.length <= 1) return false;
    final firstType = datasets.first['type'];
    return datasets.any((ds) => ds['type'] != firstType);
  }

  /// Clean dataset by removing null/empty values
  static Map<String, dynamic> _cleanDataset(Map<String, dynamic> dataset) {
    print('🧹 [ChartConfigBuilder] Cleaning dataset: $dataset');

    final cleaned = <String, dynamic>{
      'label': dataset['label'] ?? '',
      'data': (dataset['data'] as List?)?.map((e) => e as num).toList() ?? [],
    };

    // Add type for mixed charts
    final type = dataset['type'];
    if (type != null && type.toString().isNotEmpty) {
      cleaned['type'] = type;
    }

    // Add optional properties if present and not empty
    _addIfPresent(cleaned, dataset, 'borderColor');
    _addIfPresent(cleaned, dataset, 'backgroundColor');
    _addIfPresent(cleaned, dataset, 'borderWidth');
    _addIfPresent(cleaned, dataset, 'tension');
    _addIfPresent(cleaned, dataset, 'fill');

    print('🧹 [ChartConfigBuilder] Cleaned dataset: $cleaned');
    return cleaned;
  }

  /// Helper to add property if present and not empty
  static void _addIfPresent(
      Map<String, dynamic> target, Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value != null && !(value is String && value.isEmpty)) {
      target[key] = value;
      print('➕ [ChartConfigBuilder] Added $key: $value');
    }
  }

  /// Build Chart.js options
  static Map<String, dynamic> _buildOptions(Map<String, dynamic>? optionsProp) {
    print('⚙️ [ChartConfigBuilder] Building options from: $optionsProp');

    if (optionsProp == null) {
      return {
        'responsive': true,
        'maintainAspectRatio': false,
        'plugins': {
          'legend': {'display': true, 'position': 'top'},
          'title': {'display': false, 'text': ''},
        },
      };
    }

    return {
      'responsive': optionsProp['responsive'] ?? true,
      'maintainAspectRatio': optionsProp['maintainAspectRatio'] ?? false,
      'plugins': {
        'legend': _buildLegendOptions(optionsProp['legend']),
        'title': _buildTitleOptions(optionsProp['title']),
      },
    };
  }

  static Map<String, dynamic> _buildLegendOptions(dynamic legendProp) {
    if (legendProp is! Map) return {'display': true, 'position': 'top'};
    return {
      'display': legendProp['display'] ?? true,
      'position': legendProp['position'] ?? 'top',
    };
  }

  static Map<String, dynamic> _buildTitleOptions(dynamic titleProp) {
    if (titleProp is! Map) return {'display': false, 'text': ''};
    return {
      'display': titleProp['display'] ?? false,
      'text': titleProp['text'] ?? '',
    };
  }
}
