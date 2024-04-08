part of 'dui_text_style.dart';

DUITextStyle? _$DUITextStyleFromJson(Map<String, dynamic> json) {
  DUIFontToken? fontToken;
  final fontTokenJson = json['fontToken'];
  if (fontTokenJson is String) {
    fontToken = DUIFontToken()..value = fontTokenJson;
  } else {
    fontToken = DUIFontToken()
      ..value = fontTokenJson['value']
      ..font = DUIFont.fromJson(json['font'] ?? json);
  }

  return DUITextStyle(
      fontToken: fontToken,
      textColor: json['textColor'] as String?,
      textBgColor: json['textBgColor'] as String?,
      textDecoration: json['textDecoration'] as String?,
      textDecorationColor: json['textDecorationColor'] as String?,
      textDecorationStyle: json['textDecorationStyle'] as String?);
}
