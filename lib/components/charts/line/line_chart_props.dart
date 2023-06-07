import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'line_chart_props.g.dart';

@JsonSerializable()
class LineChartProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  DUIStyleClass? styleClass;
  late LineChartData data;

  LineChartProps();

  factory LineChartProps.fromJson(Map<String, dynamic> json) =>
      _$LineChartPropsFromJson(json);

  Map<String, dynamic> toJson() => _$LineChartPropsToJson(this);
}

@JsonSerializable()
class LineChartData {
  late List<LineChartBarData> series;
  late LineChartAxisData xAxis;
  late LineChartAxisData yAxis;

  LineChartData();

  factory LineChartData.fromJson(Map<String, dynamic> json) =>
      _$LineChartDataFromJson(json);

  Map<String, dynamic> toJson() => _$LineChartDataToJson(this);
}

@JsonSerializable()
class LineChartBarData {
  late String group;
  // late String name;
  late String? color;
  late double? width;
  late List<double> data;
  late Map<String, dynamic>? lineStyle;

  LineChartBarData();

  factory LineChartBarData.fromJson(Map<String, dynamic> json) =>
      _$LineChartBarDataFromJson(json);

  Map<String, dynamic> toJson() => _$LineChartBarDataToJson(this);
}

@JsonSerializable()
class LineChartAxisData {
  late String name;
  late num? min;
  late num? max;
  late List<String>? data;
  late String? labelFormatter;

  LineChartAxisData();

  factory LineChartAxisData.fromJson(Map<String, dynamic> json) =>
      _$LineChartAxisDataFromJson(json);

  Map<String, dynamic> toJson() => _$LineChartAxisDataToJson(this);
}
