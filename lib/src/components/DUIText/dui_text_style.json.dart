part of 'dui_text_style.dart';

DUITextStyle? _$DUITextStyleFromJson(dynamic json) {
  if (json is Map<String, dynamic> && json.isNotEmpty) {
    return _$DUITextStyleFromDictionary(json);
  }

  if (json is! String) {
    return null;
  }

  final styleClassMap = createStyleMap(json);
  if (styleClassMap.isEmpty) return null;

  return _$DUITextStyleFromDictionary(styleClassMap);
}

DUITextStyle _$DUITextStyleFromDictionary(Map<String, dynamic> json) =>
    DUITextStyle()
      ..fontToken = json['fontToken'] ?? json['ft']
      ..fontFamily = json['fontFamily'] ?? json['ff']
      ..textColor = json['textColor'] ?? json['tc']
      ..textBgColor = json['textBgColor'] ?? json['tbc']
      ..textDecoration = json['textDecoration'] ?? json['td']
      ..textDecorationColor = json['textDecorationColor'] ?? json['tdc']
      ..textDecorationStyle = json['textDecorationStyle'] ?? json['tds'];
