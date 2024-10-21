import 'package:json_annotation/json_annotation.dart';

import '../DUICornerRadius/dui_corner_radius.dart';

part 'dui_border.g.dart';

@JsonSerializable()
class DUIBorder {
  String? borderStyle;
  double? borderWidth;
  String? borderColor;
  DUICornerRadius? borderRadius;

  DUIBorder();

  factory DUIBorder.fromJson(Map<String, dynamic> json) =>
      _$DUIBorderFromJson(json);

  Map<String, dynamic> toJson() => _$DUIBorderToJson(this);
}
