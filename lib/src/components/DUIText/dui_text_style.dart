import 'package:digia_ui/src/Utils/dui_font.dart';

part 'dui_text_style.json.dart';

class DUIFontToken {
  String? value;
  DUIFont? font;
}

class DUITextStyle {
  DUIFontToken? fontToken;
  String? textColor;
  String? textBgColor;
  String? textDecoration;
  String? textDecorationColor;
  String? textDecorationStyle;

  DUITextStyle(
      {this.fontToken,
      this.textColor,
      this.textBgColor,
      this.textDecoration,
      this.textDecorationColor,
      this.textDecorationStyle});

  static DUITextStyle? fromJson(dynamic json) => _$DUITextStyleFromJson(json);

  DUITextStyle copyWith({
    DUIFontToken? fontToken,
    String? textColor,
    String? textBgColor,
    String? textDecoration,
    String? textDecorationColor,
    String? textDecorationStyle,
  }) {
    return DUITextStyle(
      textBgColor: textBgColor ?? this.textBgColor,
      textColor: textColor ?? this.textColor,
      textDecoration: textDecoration ?? this.textDecoration,
      textDecorationColor: textDecorationColor ?? this.textDecorationColor,
      textDecorationStyle: textDecorationStyle ?? this.textDecorationStyle,
    );
  }
}
