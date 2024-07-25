import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/expr.dart';
import '../../Utils/util_functions.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUIChartBuilder extends DUIWidgetBuilder {
  DUIChartBuilder({required super.data});

  static DUIChartBuilder create(DUIWidgetJsonData data) {
    return DUIChartBuilder(data: data);
  }

  factory DUIChartBuilder.fromProps(Map<String, dynamic> props) {
    return DUIChartBuilder(
      data: DUIWidgetJsonData(type: 'digia/lineChart', props: props),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: eval<double>(data.props['aspectRatio'], context: context) ?? 1,
      child: LineChart(
        LineChartData(
          extraLinesData: ExtraLinesData(
              horizontalLines: eval<List>(
                          data.props['extraLines']['horizontalLines'],
                          context: context)
                      ?.map((e) {
                    return HorizontalLine(
                      y: eval<double>(e['linePoint'], context: context) ?? 0,
                      color: makeColor(
                          eval<String>(e['color'], context: context)),
                      strokeWidth:
                          eval<double>(e['strokeWidth'], context: context) ??
                              2,
                      dashArray: (eval<int>(e['dashArray']['gap'],
                                      context: context) !=
                                  null &&
                              eval<int>(e['dashArray']['length'],
                                      context: context) !=
                                  null)
                          ? [
                              eval<int>(e['dashArray']['gap'],
                                  context: context)!,
                              eval<int>(e['dashArray']['length'],
                                  context: context)!
                            ]
                          : null,
                    ); 
                  }).toList() ??
                  [] as List <HorizontalLine>),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: eval<List>(data.props['lines'], context: context)
                  ?.map((e) {
                return LineChartBarData(
                  isStepLineChart: false,
                  spots: eval<List>(e['spots'], context: context)?.map((e) {
                    //todo uppercase p in y point
                        return FlSpot(e['xPoint'].toDouble(), e['ypoint'].toDouble());
                      }).toList() ??
                      [],
                  isCurved:
                      eval<bool>(e['isCurved'], context: context) ?? false,
                  barWidth:  eval<double>(e['barWidth'], context: context) ?? 2,
                  color: makeColor(
                      eval<String>(e['lineColor'], context: context)),
                  belowBarData: BarAreaData(
                      show: true,
                      color: makeColor(eval<String>(
                          e['belowBarData']['color'],
                          context: context)),
                      gradient: _toGradiant(
                          eval<Map<String, dynamic>>(
                              e['belowBarData']['gradiant'],
                              context: context),
                          context)),
                );
              }).toList() ??
              [],
          borderData: FlBorderData(
            show: false,
          ),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  Gradient? _toGradiant(Map<String, dynamic>? data, BuildContext context) {
    if (data == null) return null;

    final type = data['type'] as String?;

    switch (type) {
      case 'linear':
        final colors = (data['colorList'] as List?)
            ?.map((e) => makeColor(
                eval<String>(e['color'] as String?, context: context)))
            .nonNulls
            .toList();

        if (colors == null || colors.isEmpty) return null;

        final stops = (data['colorList'] as List?)
            ?.map((e) => NumDecoder.toDouble(e['stop']))
            .nonNulls
            .toList();

        final rotationInRadians = NumDecoder.toInt(data['angle'])
            .let((p0) => GradientRotation(p0 / 180.0 * math.pi));

        return LinearGradient(
            colors: colors,
            stops: stops?.length == colors.length ? stops! : null,
            transform: rotationInRadians);

      default:
        return null;
    }
  }
}
