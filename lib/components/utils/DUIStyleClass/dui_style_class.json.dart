part of 'dui_style_class.dart';

DUIStyleClass? _$DUIStyleClassFromJson(dynamic json) {
  if (json is Map<String, dynamic>) {
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
      ..cornerRadius =
          DUICornerRadius.fromJson(json['cornerRadius'] ?? json['cr'])
      ..alignment = json['alignment'] ?? json['al']
      ..height = json['height'] ?? json['h']
      ..width = json['width'] ?? json['w'];
