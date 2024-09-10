import 'package:json_annotation/json_annotation.dart';

part 'dui_styled_vertical_divider_props.g.dart';

@JsonSerializable()
class DUIStyledVerticalDividerProps {
  double? width;
  double? thickness;
  double? indent;
  double? endIndent;
  Map<String, dynamic>? colorType;
  Map<String, dynamic>? borderPattern;

  DUIStyledVerticalDividerProps({
    this.thickness,
    this.indent,
    this.endIndent,
    this.width,
    this.colorType,
    this.borderPattern,
  });

  factory DUIStyledVerticalDividerProps.fromJson(dynamic json) =>
      _$DUIStyledVerticalDividerPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIStyledVerticalDividerPropsToJson(this);
}
