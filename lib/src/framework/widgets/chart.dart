import 'package:chartjs_flutter/chartjs_flutter.dart';
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
    // Debug: Print props before evaluation
    print('🔍 [Chart Debug] Raw props.chartType: ${props.chartType}');
    print('🔍 [Chart Debug] Raw props.labels: ${props.labels}');
    print('🔍 [Chart Debug] Raw props.chartData: ${props.chartData}');
    print('🔍 [Chart Debug] Raw props.options: ${props.options}');

    // Evaluate ExprOr values using payload.evalExpr (same as rich_text.dart)
    final chartType = payload.evalExpr(props.chartType) ?? 'line';
    final labels = payload.evalExpr(props.labels);
    final chartDatasets = payload.evalExpr(props.chartData);
    final options = props.options;

    // Debug: Print evaluated values
    print('✅ [Chart Debug] Evaluated chartType: $chartType (${chartType.runtimeType})');
    print('✅ [Chart Debug] Evaluated labels: $labels (${labels.runtimeType})');
    print('✅ [Chart Debug] Evaluated chartDatasets: $chartDatasets (${chartDatasets.runtimeType})');
    print('✅ [Chart Debug] Options: $options');

    // Return placeholder if no chart data is provided
    if (chartDatasets == null ||
        chartDatasets is! List ||
        chartDatasets.isEmpty) {
      print('⚠️ [Chart Debug] No valid chart data provided');
      return const SizedBox(
        width: 400,
        height: 300,
        child: Center(child: Text('No chart data provided.')),
      );
    }

    print('🔄 [Chart Debug] Building chart config...');

    // Convert flat structure to Chart.js format
    final chartConfig = ChartConfigBuilder.buildChartConfig(
      chartType: chartType,
      labels: labels,
      datasets: chartDatasets.cast<Map<String, dynamic>>(),
      options: options,
    );

    print('✅ [Chart Debug] Chart config built: $chartConfig');

    return SizedBox(
      width: 400,
      height: 300,
      child: ChartJsWidget(
        chartConfig: chartConfig,
      ),
    );
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

    print('🔧 [ChartConfigBuilder] isMixed: $isMixed, effectiveType: $effectiveType');

    // Convert labels to List<String>
    final labelsList = labels is List 
        ? labels.map((e) => e.toString()).toList() 
        : <String>[];

    print('🔧 [ChartConfigBuilder] labelsList: $labelsList');

    final cleanedDatasets = datasets.map((dataset) => _cleanDataset(dataset)).toList();
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
