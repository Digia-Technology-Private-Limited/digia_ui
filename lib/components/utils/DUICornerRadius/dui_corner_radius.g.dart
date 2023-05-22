// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_corner_radius.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICornerRadius _$DUICornerRadiusFromJson(Map<String, dynamic> json) =>
    DUICornerRadius(
      bottomLeft: (json['bottomLeft'] as num?)?.toDouble() ?? 0,
      bottomRight: (json['bottomRight'] as num?)?.toDouble() ?? 0,
      topLeft: (json['topLeft'] as num?)?.toDouble() ?? 0,
      topRight: (json['topRight'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$DUICornerRadiusToJson(DUICornerRadius instance) =>
    <String, dynamic>{
      'bottomLeft': instance.bottomLeft,
      'bottomRight': instance.bottomRight,
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
    };
