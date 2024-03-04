// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_font.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIFont _$DUIFontFromJson(Map<String, dynamic> json) => DUIFont()
  ..weight = json['weight'] as String?
  ..size = (json['size'] as num?)?.toDouble()
  ..height = (json['height'] as num?)?.toDouble()
  ..style = json['style'] as String?
  ..fontFamily = json['font-family'] as String?;

Map<String, dynamic> _$DUIFontToJson(DUIFont instance) => <String, dynamic>{
      'weight': instance.weight,
      'size': instance.size,
      'height': instance.height,
      'style': instance.style,
      'fontFamily': instance.fontFamily,
    };
