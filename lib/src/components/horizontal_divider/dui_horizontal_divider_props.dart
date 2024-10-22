import 'package:json_annotation/json_annotation.dart';
part 'dui_horizontal_divider_props.g.dart';

@JsonSerializable()
class DUIHorizonatalDividerProps {
  String? lineStyle;
  double? height;
  String? color;
  double? thickness;
  double? indent;
  double? endIndent;

  DUIHorizonatalDividerProps({
    this.lineStyle,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
  });

  factory DUIHorizonatalDividerProps.fromJson(Map<String, dynamic> json) =>
      _$DUIHorizonatalDividerPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIHorizonatalDividerPropsToJson(this);
}
