part of 'dui_style_class.dart';

DUIStyleClass? _$DUIStyleClassFromJson(dynamic json) {
  if (json is Map<String, dynamic> && json.isNotEmpty) {
    return _$DUIStyleClassFromDictionary(json);
  }

  if (json is! String) {
    return null;
  }

  final styleClassMap = createStyleMap(json);
  if (styleClassMap.isEmpty) return null;

  return _$DUIStyleClassFromDictionary(styleClassMap);
}

DUIStyleClass _$DUIStyleClassFromDictionary(Map<String, dynamic> json) =>
    DUIStyleClass()
      ..padding = DUIInsets.fromJson(json['padding'] ?? json['p'])
      ..margin = DUIInsets.fromJson(json['margin'] ?? json['m'])
      ..bgColor =
          (json['bgColor'] ?? json['backgroundColor'] ?? json['bgc']) as String?
      ..border = DUIBorder.fromJson(json['border'] ?? json)
      ..alignment = json['alignment'] ?? json['al']
      ..height = json['height']?.toString() ?? json['h']?.toString()
      ..width = json['width']?.toString() ?? json['w']?.toString();
