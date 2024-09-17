import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWLineChart extends VirtualLeafStatelessWidget {
  VWLineChart(
      {required super.props,
      required super.commonProps,
      required super.parent,
      required super.refName});

  @override
  Widget render(RenderPayload payload) {
    final LineChartData chartData = LineChartData(
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      extraLinesData: _toExtraLinesData(
        payload,
        (props.toProps('extraLines')) ?? Props.empty(),
      ),
      titlesData: const FlTitlesData(show: false),
      lineBarsData: _toLineBarsData(
            payload,
            props.getList('lines').cast(),
          ) ??
          [],
    );

    return LineChart(chartData);
  }
}

List<Props?>? _getSpots(RenderPayload payload, Object? input) {
  if (input == null) return null;

  if (input is List<Props?>) return input;

  if (input is! String) return null;

  return tryJsonDecode(input) ?? payload.eval<List>(input);
}

List<LineChartBarData>? _toLineBarsData(RenderPayload payload, lines) {
  if (lines == null || lines.isEmpty) return null;

  return lines.map((line) {
    // final List<FlSpot>? spots = _getSpots(payload, (line as Map)['spots'])
    //     ?.map((s) => ifNotNull2(line.getDouble('s['x'],')).
    //        line.getDouble(s['y']) (x, y) => FlSpot(x, y))
    //     .nonNulls
    //     .toList() as List<FlSpot>;

    final List<FlSpot>? spots = _getSpots(payload, line.get('spots'))
        ?.map((s) => ifNotNull2(
            s?.getDouble('x'), s?.getDouble('y'), (x, y) => FlSpot(x, y)))
        .nonNulls
        .toList();

    return LineChartBarData(
      spots: spots ?? [],
      // isCurved: eval<bool>(line['isCurved'], context: context) ?? false,
      isCurved: payload.eval<bool>(line.get('isCurved')) ?? false,
      barWidth: payload.eval<double>(
            line.get('barWidth'),
          ) ??
          2,
      color: makeColor(payload.eval<String>(line.get('lineColor'))),
      belowBarData: _toBelowbarData(payload, (line.toProps('belowBarData'))),
    );
  }).toList();
}

BarAreaData? _toBelowbarData(RenderPayload payload, Props? props) {
  if (props == null || props.isEmpty) return null;

  return BarAreaData(
    show: payload.eval<bool>(
          props.get('show'),
        ) ??
        false,
    color: makeColor(payload.eval<String>(
      props.getString('color'),
    )),
    gradient: toGradient(props.getMap('gradiant'), payload.buildContext),
  );
}

ExtraLinesData? _toExtraLinesData(RenderPayload payload, Props? props) {
  if (props == null || props.isEmpty) return null;

  final showExtraLines = payload.eval<bool>(
        props.get('show'),
      ) ??
      false;

  if (!showExtraLines) return null;

  List<int>? toDashArray(dynamic dashArray) {
    return ifNotNull2(payload.eval<int>(dashArray['length'])!,
        payload.eval<int>(dashArray['gap'])!, (p0, p1) => [p0, p1]);
  }

  List<HorizontalLine>? horizontalLines =
      props.getList('horizontalLines').cast()?.map((e) {
    return HorizontalLine(
      y: payload.eval<double>(e['linePoint']) ?? 0,
      color: makeColor(payload.eval<String>(e['color'])),
      strokeWidth: payload.eval<double>(e['strokeWidth']) ?? 2,
      dashArray: toDashArray(e['dashArray']),
    );
  }).toList();

  List<VerticalLine>? verticalLines =
      props.getList('verticalLines').cast()?.map((e) {
    return VerticalLine(
      x: payload.eval<double>(e['linePoint']) ?? 0,
      color: makeColor(payload.eval<String>(e['color'])),
      strokeWidth: payload.eval<double>(e['strokeWidth']) ?? 2,
      dashArray: toDashArray(e['dashArray']),
    );
  }).toList();

  return ExtraLinesData(
      horizontalLines: horizontalLines ?? [],
      verticalLines: verticalLines ?? []);
}
