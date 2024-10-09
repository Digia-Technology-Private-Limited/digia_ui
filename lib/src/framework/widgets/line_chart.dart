import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWLineChart extends VirtualLeafStatelessWidget<Props> {
  VWLineChart({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final LineChartData chartData = LineChartData(
      minX: 0,
      minY: 0,
      maxX: payload.eval(props.get('maxX')),
      maxY: payload.eval(props.get('maxY')),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      extraLinesData: _toExtraLinesData(
        payload,
        props.toProps('extraLines') ?? Props.empty(),
      ),
      titlesData: _toSideTitlesData(
        payload,
        props.toProps('sideTitles') ?? Props.empty(),
      ),
      lineBarsData: _toLineBarsData(payload, props.getList('lines')) ?? [],
    );

    return LineChart(chartData);
  }
}

FlTitlesData _toSideTitlesData(RenderPayload payload, Props? props) {
  if (props == null || props.isEmpty) return const FlTitlesData(show: false);

  if (!(payload.eval<bool>(props.get('show')) ?? false)) {
    return const FlTitlesData(show: false);
  }
  return FlTitlesData(
    show: payload.eval<bool>(props.get('show'))!,
    bottomTitles: getSideTitlesData(
      payload,
      props.toProps('bottomTitles') ?? Props.empty(),
    ),
  );
}

AxisTitles getSideTitlesData(RenderPayload payload, Props? props) {
  if (props == null || props.isEmpty) return const AxisTitles();
  if (!(payload.eval<bool>(props.get('show')) ?? false)) {
    return const AxisTitles(sideTitles: SideTitles());
  }
  return AxisTitles(
    axisNameWidget: payload.eval<String>(props.get('')) != null
        ? Text(
            payload.eval<String>(props.get(''))!,
            style: payload.getTextStyle(props.getMap('axisLabelStyle')),
          )
        : null,
    sideTitles: SideTitles(
        showTitles: payload.eval<bool>(props.get('show'))!,
        getTitlesWidget: (value, meta) {
          final titleTextList =
              payload.eval<List>(props.get('titleList'))?.cast<String>();
          if (titleTextList == null || titleTextList.isEmpty) return Text('');
          return getSideTitleWidget(
            value,
            titleTextList,
            payload.getTextStyle(
              props.getMap('titleStyle'),
            ),
          );
        }),
  );
}

Widget getSideTitleWidget(double value, List<String> list, TextStyle? style) {
  return Text(
    list[value.toInt()],
    style: style,
  );
}

List<Props>? _getSpots(RenderPayload payload, Object? input) {
  if (input == null) return null;

  if (input is List<Props>) return input;

  if (input is! String) return null;

  List? list = tryJsonDecode(input) ?? payload.eval<List>(input);
  return list?.map((map) => Props(map)).toList();
}

List<LineChartBarData>? _toLineBarsData(RenderPayload payload, List? lines) {
  if (lines == null || lines.isEmpty) return null;

  return lines.map((lineData) => Props(lineData)).map((line) {
    final spots = _getSpots(payload, line.get('spots'))
        ?.map((s) => ifNotNull2(
            s.getDouble('x'), s.getDouble('y'), (x, y) => FlSpot(x, y)))
        .nonNulls
        .toList();

    return LineChartBarData(
      spots: spots ?? [],
      isCurved: payload.eval<bool>(line.get('isCurved')) ?? false,
      barWidth: payload.eval<double>(line.get('barWidth')) ?? 2,
      color: makeColor(payload.eval<String>(line.get('lineColor'))),
      belowBarData: _toBelowBarData(payload, line.toProps('belowBarData')),
    );
  }).toList();
}

BarAreaData? _toBelowBarData(RenderPayload payload, Props? props) {
  if (props == null || props.isEmpty) return null;

  return BarAreaData(
    show: payload.eval<bool>(props.get('show')) ?? false,
    color: makeColor(payload.eval<String>(props.getString('color'))),
    gradient: toGradient(props.getMap('gradiant'), payload.buildContext),
  );
}

ExtraLinesData? _toExtraLinesData(RenderPayload payload, Props? props) {
  if (props == null || props.isEmpty) return null;

  if (!(payload.eval<bool>(props.get('show')) ?? false)) return null;

  List<HorizontalLine> horizontalLines = props
          .getList('horizontalLines')
          ?.map((e) => _toHorizontalLine(payload, e))
          .whereType<HorizontalLine>()
          .toList() ??
      [];

  List<VerticalLine> verticalLines = props
          .getList('verticalLines')
          ?.map((e) => _toVerticalLine(payload, e))
          .whereType<VerticalLine>()
          .toList() ??
      [];

  return ExtraLinesData(
    horizontalLines: horizontalLines,
    verticalLines: verticalLines,
  );
}

HorizontalLine? _toHorizontalLine(RenderPayload payload, dynamic e) {
  final map = e as Map?;
  if (map == null) return null;

  return HorizontalLine(
    y: payload.eval<double>(map['linePoint']) ?? 0,
    color: makeColor(payload.eval<String>(map['color'])),
    strokeWidth: payload.eval<double>(map['strokeWidth']) ?? 2,
    dashArray: _toDashArray(map['dashArray']),
  );
}

VerticalLine? _toVerticalLine(RenderPayload payload, dynamic e) {
  final map = e as Map?;
  if (map == null) return null;

  return VerticalLine(
    x: payload.eval<double>(map['linePoint']) ?? 0,
    color: makeColor(payload.eval<String>(map['color'])),
    strokeWidth: payload.eval<double>(map['strokeWidth']) ?? 2,
    dashArray: _toDashArray(map['dashArray']),
  );
}

List<int>? _toDashArray(dynamic dashArray) {
  if (dashArray is Map) {
    return ifNotNull2(
      dashArray['length'] as int?,
      dashArray['gap'] as int?,
      (length, gap) => [length, gap],
    );
  }
  return null;
}
