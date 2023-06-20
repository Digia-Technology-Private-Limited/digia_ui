import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/charts/dui_chart_props.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart.props.g.dart';

@JsonSerializable()
class EEChartProps {
  late DUITextProps heading;
  late DUITextProps mainText;
  late DUITextProps comparisonText;
  late DUIChartProps chartData;
  late DUITextProps bottomText;

  EEChartProps();

  factory EEChartProps.fromJson(Map<String, dynamic> json) =>
      _$EEChartPropsFromJson(json);

  Map<String, dynamic> toJson() => _$EEChartPropsToJson(this);
}
