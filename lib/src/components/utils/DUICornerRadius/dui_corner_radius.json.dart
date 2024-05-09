part of 'dui_corner_radius.dart';

DUICornerRadius _$DUICornerRadiusFromJson(dynamic json) {
  if (json == null) {
    return DUICornerRadius();
  }

  if (json is String) {
    return _$DUICornerRadiusFromListOfString(json.split(','));
  }

  if (json is int) {
    return _$DUICornerRadiusFromListOfDouble([json.toDouble()]);
  }

  if (json is double) {
    return _$DUICornerRadiusFromListOfDouble([json]);
  }

  if (json is List<String>) {
    return _$DUICornerRadiusFromListOfString(json);
  }

  if (json is List<int>) {
    return _$DUICornerRadiusFromListOfDouble(json.map((e) => e.toDouble()).toList());
  }

  if (json is List<double>) {
    return _$DUICornerRadiusFromListOfDouble(json);
  }

  if (json is Map<String, dynamic>) {
    return DUICornerRadius(
      topLeft: (json['topLeft'] as num?)?.toDouble() ?? 0,
      topRight: (json['topRight'] as num?)?.toDouble() ?? 0,
      bottomRight: (json['bottomRight'] as num?)?.toDouble() ?? 0,
      bottomLeft: (json['bottomLeft'] as num?)?.toDouble() ?? 0,
    );
  }

  return DUICornerRadius();
}

DUICornerRadius _$DUICornerRadiusFromListOfString(List<String> list) {
  final parsedList = list
      .map((e) {
        if (e == 'inf' || e == 'infinity') {
          return double.infinity;
        }

        return double.tryParse(e);
      })
      .nonNulls
      .toList();
  return _$DUICornerRadiusFromListOfDouble(parsedList);
}

DUICornerRadius _$DUICornerRadiusFromListOfDouble(List<double> list) {
  if (list.length == 1) {
    return DUICornerRadius(
      topLeft: list.first,
      topRight: list.first,
      bottomRight: list.first,
      bottomLeft: list.first,
    );
  }

  if (list.length == 4) {
    return DUICornerRadius(
      topLeft: list[0],
      topRight: list[1],
      bottomRight: list[2],
      bottomLeft: list[3],
    );
  }

  return DUICornerRadius();
}

Map<String, dynamic> _$DUICornerRadiusToJson(DUICornerRadius instance) => <String, dynamic>{
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
      'bottomRight': instance.bottomRight,
      'bottomLeft': instance.bottomLeft,
    };
