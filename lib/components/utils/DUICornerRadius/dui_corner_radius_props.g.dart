// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_corner_radius_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICornerRadius _$DUICornerRadiusFromJson(Map<String, dynamic> json) =>
    DUICornerRadius()
      ..bottomLeft = (json['bottomLeft'] as num).toDouble()
      ..bottomRight = (json['bottomRight'] as num).toDouble()
      ..topLeft = (json['topLeft'] as num).toDouble()
      ..topRight = (json['topRight'] as num).toDouble();

Map<String, dynamic> _$DUICornerRadiusToJson(DUICornerRadius instance) =>
    <String, dynamic>{
      'bottomLeft': instance.bottomLeft,
      'bottomRight': instance.bottomRight,
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
    };
