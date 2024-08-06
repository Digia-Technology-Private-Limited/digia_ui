import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
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
    bool extraLines =
        eval<bool>(data.props['extraLines']['show'], context: context) ?? false;

    List<HorizontalLine>? horizontalLines = eval<List>(
            data.props['extraLines']['horizontalLines'],
            context: context)
        ?.map((e) {
      return HorizontalLine(
        y: eval<double>(e['linePoint'], context: context) ?? 0,
        color: makeColor(eval<String>(e['color'], context: context)),
        strokeWidth: eval<double>(e['strokeWidth'], context: context) ?? 2,
        dashArray: ifNotNull2(
            eval<int>(e['dashArray']['length'], context: context)!,
            eval<int>(e['dashArray']['gap'], context: context)!,
            (p0, p1) => [p0, p1]),
      );
    }).toList();
    List<VerticalLine>? verticalLines =
        eval<List>(data.props['extraLines']['verticalLines'], context: context)
            ?.map((e) {
      return VerticalLine(
        x: eval<double>(e['linePoint'], context: context) ?? 0,
        color: makeColor(eval<String>(e['color'], context: context)),
        strokeWidth: eval<double>(e['strokeWidth'], context: context) ?? 2,
        dashArray: ifNotNull2(
            eval<int>(e['dashArray']['length'], context: context)!,
            eval<int>(e['dashArray']['gap'], context: context)!,
            (p0, p1) => [p0, p1]),
      );
    }).toList();



    dynamic safeJsonDecode(String input) {
      try {
        return jsonDecode(input);
      } on FormatException catch (e) {
        print('Invalid JSON format: $e ${ eval(input, context: context)}');
        return  eval(input, context: context);
      } on TypeError catch (e) {
        print('Type error: $e  ${ eval(input, context: context)}');
        return  eval(input, context: context);
      } catch (e) {
        print('Unknown error: $e  ${ eval(input, context: context)}');
        return  eval(input, context: context);
      }
    }

    final LineChartData chartData = LineChartData(
      extraLinesData: extraLines
          ? ExtraLinesData(
              horizontalLines: horizontalLines ?? [],
              verticalLines: verticalLines ?? [],
            )
          : null,
      titlesData: const FlTitlesData(show: false),
      lineBarsData: eval<List>(data.props['lines'], context: context)?.map((e) {
//function => try catch =>
            final List? spots =
                safeJsonDecode(e['spots']);
            return LineChartBarData(
              isStepLineChart: false,
              spots: spots?.map((s) {
                    return FlSpot(s['x'].toDouble(), s['y'].toDouble());
                  }).toList() ??
                  [],
              isCurved: eval<bool>(e['isCurved'], context: context) ?? false,
              barWidth: eval<double>(e['barWidth'], context: context) ?? 2,
              color: makeColor(eval<String>(e['lineColor'], context: context)),
              belowBarData: BarAreaData(
                  show:
                      eval<bool>(e['belowBarData']['show'], context: context) ??
                          false,
                  color: makeColor(eval<String>(e['belowBarData']['color'],
                      context: context)),
                  gradient: toGradiant(
                      eval<Map<String, dynamic>>(e['belowBarData']['gradiant'],
                          context: context),
                      context)),
            );
          }).toList() ??
          [],
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(show: false),
    );

    return LineChart(
      chartData,
    );
  }
}
