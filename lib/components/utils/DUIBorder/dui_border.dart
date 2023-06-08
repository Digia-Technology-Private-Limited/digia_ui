import 'package:digia_ui/Utils/util_functions.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';

part 'dui_border.json.dart';

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
