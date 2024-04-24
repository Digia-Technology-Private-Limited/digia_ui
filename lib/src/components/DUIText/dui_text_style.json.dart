part of 'dui_text_style.dart';

DUITextStyle? _$DUITextStyleFromJson(dynamic json) {
  if (json == null) return null;

  DUIFontToken? fontToken;

  final fontTokenJson = json['fontToken'];
  if (fontTokenJson == null) {
    fontToken = null;
  } else if (fontTokenJson is String) {
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
