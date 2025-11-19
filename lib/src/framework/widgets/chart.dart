import 'package:chartjs_flutter/chartjs_flutter.dart';
import 'package:flutter/material.dart';

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
    final useDataSource = props.useDataSource ?? false;

    if (useDataSource) {
      // --- Direct Data Source Mode ---
      final dataSource = props.dataSource;
      if (dataSource == null) {
        return _buildErrorWidget(
            'Chart is configured to use a data source, but the `dataSource` property is not set.');
      }

      // Properly evaluate the dataSource expression
      final chartConfig = payload.evalExpr(dataSource);

      if (chartConfig == null) {
        return _buildErrorWidget(
            'The provided `dataSource` is null or could not be evaluated.');
      }

      if (chartConfig is! Map<String, dynamic>) {
        return _buildErrorWidget(
            'The provided `dataSource` did not evaluate to a valid chart configuration map. Got type: ${chartConfig.runtimeType}');
      }

      return ChartJsWidget(
        chartConfig: chartConfig,
      );
    } else {
      // --- Individual Properties Mode ---
      return _buildFromProperties(payload);
    }
  }

  Widget _buildFromProperties(RenderPayload payload) {
    // --- Property Resolution ---
    // Use data directly from individual props.
    final chartType = payload.evalExpr(props.chartType) ?? 'line';

    final labels = payload.evalExpr(props.labels);

    final List<dynamic> chartDatasets = (props.chartData
            ?.deepEvaluate(payload.scopeContext) as List<dynamic>?) ??
        <dynamic>[];

    final options = props.options;

    // --- Widget Rendering ---
    // Return placeholder if no chart data is provided
    if (chartDatasets.isEmpty) {
      return const Center(child: Text('No chart data provided.'));
    }

    // Validate chart type compatibility
    final validationError =
        _validateChartTypes(chartDatasets.cast<Map<String, dynamic>>());
    if (validationError != null) {
      return _buildErrorWidget(validationError);
    }

    // Convert flat structure to Chart.js format
    final chartConfig = ChartConfigBuilder.buildChartConfig(
      chartType: chartType,
      labels: labels,
      datasets: chartDatasets.cast<Map<String, dynamic>>(),
      options: options,
    );

    return ChartJsWidget(
      chartConfig: chartConfig,
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
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
              errorMessage,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
    final datasetTypes =
        datasets.map((ds) => ds['type'] as String?).whereType<String>().toSet();

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
    // Determine if this is a mixed chart
    final isMixed = chartType == 'mixed' || _hasMixedTypes(datasets);
    final effectiveType = isMixed ? 'bar' : chartType;

    // Convert labels to List<String>
    final labelsList =
        labels is List ? labels.map((e) => e.toString()).toList() : <String>[];

    final cleanedDatasets =
        datasets.map((dataset) => _cleanDataset(dataset)).toList();

    return {
      'type': effectiveType,
      'data': {
        'labels': labelsList,
        'datasets': cleanedDatasets,
      },
      'options':
          _buildOptions(options, datasets), // Pass datasets to _buildOptions
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

    return cleaned;
  }

  /// Helper to add property if present and not empty
  static void _addIfPresent(
      Map<String, dynamic> target, Map<String, dynamic> source, String key) {
    final value = source[key];
    if (value != null && !(value is String && value.isEmpty)) {
      target[key] = value;
    }
  }

  /// Build Chart.js options
  static Map<String, dynamic> _buildOptions(
      Map<String, dynamic>? optionsProp, List<Map<String, dynamic>> datasets) {
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
        'legend': _buildLegendOptions(optionsProp['legend'], datasets),
        'title': _buildTitleOptions(optionsProp['title']),
      },
    };
  }

  static Map<String, dynamic> _buildLegendOptions(
      dynamic legendProp, List<Map<String, dynamic>> datasets) {
    if (legendProp is! Map) return {'display': true, 'position': 'top'};

    // --- Process label styles for the legend ---
    final Map<String, dynamic> fontStyles = {
      'family': 'Roboto',
      'size': 12,
      'style': 'normal',
      'weight': 'normal',
      'lineHeight': 1.2,
    };
    String defaultColor = '#666';

    // If there's at least one dataset, use its style as the base
    if (datasets.isNotEmpty) {
      final firstDataset = datasets.first;
      final firstLabelStyle = firstDataset['labelStyle'] as Map?;
      if (firstLabelStyle != null) {
        final fontOptions = _buildFontOptions(firstLabelStyle);
        fontStyles.addAll(fontOptions);
        defaultColor = firstLabelStyle['textColor'] ?? defaultColor;
      }
    }

    return {
      'display': legendProp['display'] ?? true,
      'position': legendProp['position'] ?? 'top',
      'labels': {
        'font': fontStyles,
        'color': defaultColor,
      },
    };
  }

  static Map<String, dynamic> _buildTitleOptions(dynamic titleProp) {
    if (titleProp is! Map) return {'display': false, 'text': ''};

    final titleStyle = titleProp['titleStyle'] as Map?;
    final titleFontOptions = _buildFontOptions(titleStyle);
    final titleColor = titleStyle?['textColor'] as String?;

    return {
      'display': titleProp['display'] ?? false,
      'text': titleProp['text'] ?? '',
      'font': titleFontOptions,
      if (titleColor != null) 'color': titleColor,
    };
  }

  /// Reusable helper to build a Chart.js font object from our style map
  static Map<String, dynamic> _buildFontOptions(Map? style) {
    final Map<String, dynamic> fontStyles = {};
    if (style == null) return fontStyles;

    final fontToken = style['fontToken'] as Map?;
    final font = fontToken?['font'] as Map?;

    if (font != null) {
      if (font['fontFamily'] != null) {
        fontStyles['family'] = font['fontFamily'];
      }
      if (font['size'] != null) {
        fontStyles['size'] = font['size'];
      }
      if (font['height'] != null) {
        fontStyles['lineHeight'] = font['height'];
      }

      // Map 'isItalic' boolean to 'italic' or 'normal' string
      final isItalic = font['isItalic'] as bool?;
      fontStyles['style'] = isItalic == true ? 'italic' : 'normal';

      // Map 'weight' string (e.g., "Bold", "Normal", "500") to valid Chart.js values
      final weightValue = font['weight'] as String?;
      switch (weightValue?.toLowerCase()) {
        case 'bold':
          fontStyles['weight'] = 'bold';
          break;
        case 'normal':
          fontStyles['weight'] = 'normal';
          break;
        default:
          if (weightValue != null) {
            final weightNum = int.tryParse(weightValue);
            if (weightNum != null) {
              fontStyles['weight'] = weightNum;
            }
          }
          break;
      }
    }
    return fontStyles;
  }
}
