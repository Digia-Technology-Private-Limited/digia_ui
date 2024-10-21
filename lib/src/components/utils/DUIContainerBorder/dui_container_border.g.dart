// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_container_border.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIContainerBorder _$DUIContainerBorderFromJson(Map<String, dynamic> json) =>
    DUIContainerBorder()
      ..borderStyle = json['borderStyle'] as String?
      ..borderWidth = (json['borderWidth'] as num?)?.toDouble()
      ..borderColor = json['borderColor'] as String?
      ..borderRadius = json['borderRadius'] == null
          ? null
          : DUICornerRadius.fromJson(json['borderRadius'])
      ..borderGradiant = json['borderGradiant'] as Map<String, dynamic>?
      ..borderType = json['borderType'] == null
          ? null
          : BorderPatternClass.fromJson(
              json['borderType'] as Map<String, dynamic>)
      ..strokeAlign =
          $enumDecodeNullable(_$StrokeAlignEnumMap, json['strokeAlign']);

Map<String, dynamic> _$DUIContainerBorderToJson(DUIContainerBorder instance) =>
    <String, dynamic>{
      'borderStyle': instance.borderStyle,
      'borderWidth': instance.borderWidth,
      'borderColor': instance.borderColor,
      'borderRadius': instance.borderRadius,
      'borderGradiant': instance.borderGradiant,
      'borderType': instance.borderType,
      'strokeAlign': _$StrokeAlignEnumMap[instance.strokeAlign],
    };

const _$StrokeAlignEnumMap = {
  StrokeAlign.inside: 'inside',
  StrokeAlign.outside: 'outside',
  StrokeAlign.center: 'center',
};
