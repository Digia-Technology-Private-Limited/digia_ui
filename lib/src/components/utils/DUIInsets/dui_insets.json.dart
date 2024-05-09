part of 'dui_insets.dart';

DUIInsets _$DUIInsetsFromJson(dynamic json) {
  if (json is String) {
    return _$DUIInsetsFromListOfString(json.split(','));
  }

  if (json is List<String>) {
    return _$DUIInsetsFromListOfString(json);
  }

  if (json is Map<String, dynamic>) {
    return DUIInsets(
      top: json['top'] as String? ?? '0',
      bottom: json['bottom'] as String? ?? '0',
      left: json['left'] as String? ?? '0',
      right: json['right'] as String? ?? '0',
    );
  }

  return DUIInsets();
}

DUIInsets _$DUIInsetsFromListOfString(List<String> list) {
  if (list.length == 1) {
    return DUIInsets(left: list.first, top: list.first, right: list.first, bottom: list.first);
  }

  if (list.length == 2) {
    return DUIInsets(left: list.first, top: list.last, right: list.first, bottom: list.last);
  }

  if (list.length == 4) {
    return DUIInsets(left: list[0], top: list[1], right: list[2], bottom: list[3]);
  }

  return DUIInsets();
}

Map<String, dynamic> _$DUIInsetsToJson(DUIInsets instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
    };
