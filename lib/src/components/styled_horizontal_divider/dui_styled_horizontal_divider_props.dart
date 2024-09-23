import 'package:json_annotation/json_annotation.dart';

part 'dui_styled_horizontal_divider_props.g.dart';

@JsonSerializable()
class DUIStyledHorizonatalDividerProps {
  double? height;
  double? thickness;
  double? indent;
  double? endIndent;
  Map<String, dynamic>? colorType;
  Map<String, dynamic>? borderPattern;

  DUIStyledHorizonatalDividerProps({
    this.thickness,
    this.indent,
    this.endIndent,
    this.height,
    this.colorType,
    this.borderPattern,
  });

  factory DUIStyledHorizonatalDividerProps.fromJson(dynamic json) =>
      _$DUIStyledHorizonatalDividerPropsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DUIStyledHorizonatalDividerPropsToJson(this);
}
