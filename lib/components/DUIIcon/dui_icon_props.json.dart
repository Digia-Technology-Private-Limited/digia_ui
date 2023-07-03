part of 'dui_icon_props.dart';

DUIIconProps? _$DUIIconPropsFromJson(dynamic json) {
  if (json is Map<String, dynamic> && json.isNotEmpty) {
    return _$DUIIconPropsFromDictionary(json);
  }
  if (json is String) {
    return DUIIconProps(value: tryParseToInt(json));
  }
  return null;
}

DUIIconProps? _$DUIIconPropsFromDictionary(Map<String, dynamic> json) {
  return DUIIconProps(
    value: tryParseToInt(json['value']) ?? tryParseToInt(json['v']),
    size: json['size'] ?? json['s'],
    color: json['color'] ?? json['c'],
  );
}
