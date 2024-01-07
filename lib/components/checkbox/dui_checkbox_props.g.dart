// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_checkbox_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICheckboxProps _$DUICheckboxPropsFromJson(Map<String, dynamic> json) =>
    DUICheckboxProps(
      json['size'] as String?,
      json['activeBgColor'] as String?,
      json['value'] as bool?,
      DUIStyleClass.fromJson(json['styleClass']),
    );

Map<String, dynamic> _$DUICheckboxPropsToJson(DUICheckboxProps instance) =>
    <String, dynamic>{
      'size': instance.size,
      'activeBgColor': instance.activeBgColor,
      'value': instance.value,
    };
