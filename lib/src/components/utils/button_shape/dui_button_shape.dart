import 'package:digia_ui/src/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_button_shape.g.dart';

@JsonSerializable()
class DUIButtonShape {
  double? eccentricity;
  String? borderStyle;
  String? borderColor;
  String? buttonShape;
  DUICornerRadius? borderRadius;
  double? borderWidth;

  DUIButtonShape({
    this.borderColor,
    this.eccentricity,
    this.borderRadius,
    this.borderStyle,
    this.borderWidth,
    this.buttonShape,
  });

  factory DUIButtonShape.fromJson(Map<String, dynamic> json) =>
      _$DUIButtonShapeFromJson(json);

  Map<String, dynamic> toJson() => _$DUIButtonShapeToJson(this);
}
