import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

// part 'line_chart_props.g.dart';

@JsonSerializable()
class LineChartProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  DUIStyleClass? styleClass;
}

@JsonSerializable()
class LineChartData {
  late List<LineChartBarData> lines;
  late LineChartAxis axis;
}

@JsonSerializable()
class LineChartBarData {
  late String group;
  late String color;
  late double? width;
  late List<Map<String, dynamic>> points;
}

@JsonSerializable()
class LineChartAxis {
  late LineChartAxisData x;
  late LineChartAxisData y;
}

@JsonSerializable()
class LineChartAxisData {
  late String name;
  late List<LineTick>? tick;
}

@JsonSerializable()
class LineTick {
  late double value;
  late String label;
}
