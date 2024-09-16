import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUILineChartBuilder extends DUIWidgetBuilder {
  DUILineChartBuilder({required super.data});

  static DUILineChartBuilder create(DUIWidgetJsonData data) {
    return DUILineChartBuilder(data: data);
  }

  factory DUILineChartBuilder.fromProps(Map<String, dynamic> props) {
    return DUILineChartBuilder(
      data: DUIWidgetJsonData(type: 'digia/lineChart', props: props),
    );
  }

  @override
  Widget build(BuildContext context) {
    final LineChartData chartData = LineChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      extraLinesData: _toExtraLinesData(
          context, tryCast<Map<String, dynamic>>(data.props['extraLines'])),
      titlesData: const FlTitlesData(show: false),
      lineBarsData:
          _toLineBarsData(context, tryCast<List>(data.props['lines'])) ?? [],
    );

    return LineChart(chartData);
  }
}

List<dynamic>? _getSpots(BuildContext context, dynamic input) {
  if (input == null) return null;

  if (input is List) return input;

  if (input is! String) return null;

  return tryJsonDecode(input) ?? eval<List>(input, context: context);
}

List<LineChartBarData>? _toLineBarsData(
    BuildContext context, List<dynamic>? lines) {
  if (lines == null || lines.isEmpty) return null;

  return lines.map(
    (line) {
      final List<FlSpot>? spots = _getSpots(context, line['spots'])
          ?.map((s) => ifNotNull2(NumDecoder.toDouble(s['x']),
              NumDecoder.toDouble(s['y']), (x, y) => FlSpot(x, y)))
          .nonNulls
          .toList();
      return LineChartBarData(
        spots: spots ?? [],
        isCurved: eval<bool>(line['isCurved'], context: context) ?? false,
        barWidth: eval<double>(line['barWidth'], context: context) ?? 2,
        color: makeColor(eval<String>(line['lineColor'], context: context)),
        belowBarData: _toBelowbarData(
            context, tryCast<Map<String, dynamic>>(line['belowBarData'])),
      );
    },
  ).toList();
}

BarAreaData? _toBelowbarData(
    BuildContext context, Map<String, dynamic>? props) {
  if (props == null || props.isEmpty) return null;

  return BarAreaData(
      show: eval<bool>(props['show'], context: context) ?? false,
      color: makeColor(eval<String>(props['color'], context: context)),
      gradient: toGradient(
          tryCast<Map<String, dynamic>>(props['gradiant']), context));
}

ExtraLinesData? _toExtraLinesData(
    BuildContext context, Map<String, dynamic>? props) {
  if (props == null || props.isEmpty) return null;

  final showExtraLines =
      eval<bool>(props.valueFor(keyPath: 'show'), context: context) ?? false;

  if (!showExtraLines) return null;

  List<int>? toDashArray(dynamic dashArray) {
    return ifNotNull2(eval<int>(dashArray['length'], context: context)!,
        eval<int>(dashArray['gap'], context: context)!, (p0, p1) => [p0, p1]);
  }

  List<HorizontalLine>? horizontalLines = props['horizontalLines']?.map((e) {
    return HorizontalLine(
      y: eval<double>(e['linePoint'], context: context) ?? 0,
      color: makeColor(eval<String>(e['color'], context: context)),
      strokeWidth: eval<double>(e['strokeWidth'], context: context) ?? 2,
      dashArray: toDashArray(e['dashArray']),
    );
  }).toList();

  List<VerticalLine>? verticalLines = props['verticalLines']?.map((e) {
    return VerticalLine(
      x: eval<double>(e['linePoint'], context: context) ?? 0,
      color: makeColor(eval<String>(e['color'], context: context)),
      strokeWidth: eval<double>(e['strokeWidth'], context: context) ?? 2,
      dashArray: toDashArray(e['dashArray']),
    );
  }).toList();

  return ExtraLinesData(
      horizontalLines: horizontalLines ?? [],
      verticalLines: verticalLines ?? []);
}
