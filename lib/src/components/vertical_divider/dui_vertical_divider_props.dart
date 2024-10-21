import 'package:json_annotation/json_annotation.dart';
part 'dui_vertical_divider_props.g.dart';

@JsonSerializable()
class DUIVerticalDividerProps {
  String? lineStyle;
  String? color;
  double? width;
  double? thickness;
  double? indent;
  double? endIndent;

  DUIVerticalDividerProps({
    this.lineStyle,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.width,
  });

  factory DUIVerticalDividerProps.fromJson(Map<String, dynamic> json) =>
      _$DUIVerticalDividerPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIVerticalDividerPropsToJson(this);
}
