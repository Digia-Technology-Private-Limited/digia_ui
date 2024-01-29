import 'package:digia_ui/src/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_chart_props.g.dart';

@JsonSerializable()
class DUIChartProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  DUIStyleClass? styleClass;
  late DUIChartData data;

  DUIChartProps();

  factory DUIChartProps.fromJson(Map<String, dynamic> json) =>
      _$DUIChartPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIChartPropsToJson(this);
}

@JsonSerializable()
class DUIChartData {
  late String type;
  late List<DUIChartSeriesData> series;
  late DUIChartAxisData xAxis;
  late DUIChartAxisData yAxis;

  DUIChartData();

  factory DUIChartData.fromJson(Map<String, dynamic> json) =>
      _$DUIChartDataFromJson(json);

  Map<String, dynamic> toJson() => _$DUIChartDataToJson(this);
}

@JsonSerializable()
class DUIChartSeriesData {
  late String group;
  // late String name;
  late String? color;
  late double? width;
  late List<double> data;
  late Map<String, dynamic>? lineStyle;

  DUIChartSeriesData();

  factory DUIChartSeriesData.fromJson(Map<String, dynamic> json) =>
      _$DUIChartSeriesDataFromJson(json);

  Map<String, dynamic> toJson() => _$DUIChartSeriesDataToJson(this);
}

@JsonSerializable()
class DUIChartAxisData {
  late String name;
  late num? min;
  late num? max;
  late List<String>? data;
  late String? labelFormatter;

  DUIChartAxisData();

  factory DUIChartAxisData.fromJson(Map<String, dynamic> json) =>
      _$DUIChartAxisDataFromJson(json);

  Map<String, dynamic> toJson() => _$DUIChartAxisDataToJson(this);
}
