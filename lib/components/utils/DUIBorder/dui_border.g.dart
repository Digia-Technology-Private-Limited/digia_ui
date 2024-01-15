// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_border.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIBorder _$DUIBorderFromJson(Map<String, dynamic> json) => DUIBorder()
  ..borderStyle = json['borderStyle'] as String?
  ..borderWidth = (json['borderWidth'] as num?)?.toDouble()
  ..borderWidthStr = json['borderWidthStr'] as String?
  ..borderColor = json['borderColor'] as String?
  ..borderRadius = json['borderRadius'] == null
      ? null
      : DUICornerRadius.fromJson(json['borderRadius']);

Map<String, dynamic> _$DUIBorderToJson(DUIBorder instance) => <String, dynamic>{
      'borderStyle': instance.borderStyle,
      'borderWidth': instance.borderWidth,
      'borderWidthStr': instance.borderWidthStr,
      'borderColor': instance.borderColor,
      'borderRadius': instance.borderRadius,
    };
