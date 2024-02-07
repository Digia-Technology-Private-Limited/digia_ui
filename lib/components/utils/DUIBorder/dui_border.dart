import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_border.g.dart';

@JsonSerializable()
class DUIBorder {
  String? borderStyle;
  double? borderWidth;
  String? borderWidthStr;
  String? borderColor;
  DUICornerRadius? borderRadius;

  DUIBorder();

  factory DUIBorder.fromJson(dynamic json) => _$DUIBorderFromJson(json);

  Map<String, dynamic> toJson() => _$DUIBorderToJson(this);
}
