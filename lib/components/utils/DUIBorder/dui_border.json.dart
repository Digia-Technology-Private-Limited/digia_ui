part of 'dui_border.dart';

DUIBorder _$DUIBorderFromJson(dynamic json) {
  if (json == null) {
    return DUIBorder();
  }

  if (json is String) {
    final styleClassMap = createStyleMap(json);
    if (styleClassMap.isNotEmpty) {
      return _$DUIBorderFromDictionary(styleClassMap);
    }
  }

  if (json is Map<String, dynamic> && json.isNotEmpty) {
    return _$DUIBorderFromDictionary(json);
  }

  return DUIBorder();
}

DUIBorder _$DUIBorderFromDictionary(Map<String, dynamic> json) => DUIBorder()
  ..borderStyle = (json['borderStyle'] ?? json['bds']) as String?
  ..borderWidth = ((json['borderWidth'] ?? json['bdw']) as num?)?.toDouble()
  ..borderColor = (json['borderColor'] ?? json['bdc']) as String?
  ..borderRadius = (json['borderRadius'] ?? json['bdr']) == null
      ? null
      : DUICornerRadius.fromJson((json['borderRadius'] ?? json['bdr']));

Map<String, dynamic> _$DUIBorderToJson(DUIBorder instance) => <String, dynamic>{
      'borderStyle': instance.borderStyle,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderRadius': instance.borderRadius,
    };
