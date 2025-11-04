import 'package:chartjs_flutter/chart_js_widget.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/chart_props.dart';

class VWChart extends VirtualStatelessWidget<ChartProps> {
  VWChart({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName, required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final chartDataList = props.chartData; // ✅ Fixed: Use chartData instead of chartConfig

    // Return placeholder if no chart data is provided
    if (chartDataList == null || chartDataList.isEmpty) {
      return const SizedBox(
        width: 400,
        height: 300,
        child: Center(child: Text('No chart data provided.')),
      );
    }

    // Get the first chart configuration
    final chartConfigObject = chartDataList.first;

    // Extract chart configuration using the builder
    final chartConfig = ChartConfigBuilder.extractChartConfig(chartConfigObject);

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
  /// Extracts the complete chart configuration from chart data
  static Map<String, dynamic> extractChartConfig(Map<String, dynamic>? chartObject) {
    if (chartObject == null) return {};
    return {
      'type': chartObject['type'] ?? 'line',
      'data': extractChartData(chartObject['data']),
      'options': extractChartOptions(chartObject['options']),
    };
  }

  /// Extracts chart data (labels and datasets)
  static Map<String, dynamic> extractChartData(dynamic dataProp) {
    if (dataProp is! Map) return {};
    final labels =
        (dataProp['labels'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final datasets = (dataProp['datasets'] as List?)
            ?.map((dataset) => extractDataset(dataset))
            .toList() ??
        [];
    return {
      'labels': labels,
      'datasets': datasets,
    };
  }

  /// Extracts a single dataset configuration
  static Map<String, dynamic> extractDataset(dynamic dataset) {
    if (dataset is! Map) return {};

    // Helper to clean empty strings to null
    dynamic cleanValue(dynamic value) {
      if (value is String && value.isEmpty) {
        return null;
      }
      return value;
    }

    // Start with the base properties that are always present
    final Map<String, dynamic> datasetMap = {
      'label': dataset['label'] ?? '',
      'data': (dataset['data'] as List?)?.map((e) => e as num).toList() ?? [],
    };

    // Add optional properties only if they exist
    final borderColor = cleanValue(dataset['borderColor']);
    if (borderColor != null) {
      datasetMap['borderColor'] = borderColor;
    }

    final backgroundColor = cleanValue(dataset['backgroundColor']);
    if (backgroundColor != null) {
      datasetMap['backgroundColor'] = backgroundColor;
    }

    final borderWidth = cleanValue(dataset['borderWidth']);
    if (borderWidth != null) {
      datasetMap['borderWidth'] = borderWidth;
    }

    final tension = cleanValue(dataset['tension']);
    if (tension != null) {
      datasetMap['tension'] = tension;
    }

    final fill = cleanValue(dataset['fill']);
    if (fill != null) {
      datasetMap['fill'] = fill;
    }

    return datasetMap;
  }

  /// Extracts chart options (responsive, aspect ratio, plugins)
  static Map<String, dynamic> extractChartOptions(dynamic optionsProp) {
    if (optionsProp is! Map) return {};
    return {
      'responsive': optionsProp['responsive'] ?? true,
      'maintainAspectRatio': optionsProp['maintainAspectRatio'] ?? false,
      'plugins': {
        'legend': extractLegendOptions(optionsProp['legend']),
        'title': extractTitleOptions(optionsProp['title']),
      },
    };
  }

  /// Extracts legend options for Chart.js config
  static Map<String, dynamic> extractLegendOptions(dynamic legendProp) {
    if (legendProp is! Map) return {};
    return {
      'display': legendProp['display'] ?? true,
      'position': legendProp['position'] ?? 'top',
    };
  }

  /// Extracts title options for Chart.js config
  static Map<String, dynamic> extractTitleOptions(dynamic titleProp) {
    if (titleProp is! Map) return {};
    return {
      'display': titleProp['display'] ?? false,
      'text': titleProp['text'] ?? '',
    };
  }
}