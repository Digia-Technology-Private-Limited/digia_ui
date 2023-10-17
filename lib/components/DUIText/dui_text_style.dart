import 'package:digia_ui/Utils/util_functions.dart';

part 'dui_text_style.json.dart';

class DUITextStyle {
  String? fontToken;
  String? fontFamily;
  String? textColor;
  String? textBgColor;
  String? textDecoration;
  String? textDecorationColor;
  String? textDecorationStyle;

  static DUITextStyle? fromJson(dynamic json) => _$DUITextStyleFromJson(json);
}
