// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_dropdown_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIDropdownProps _$DUIDropdownPropsFromJson(Map<String, dynamic> json) =>
    DUIDropdownProps(
      json['borderRadius'] as String,
      json['alignment'] as String?,
      json['dropdownColor'] as String?,
      json['focusColor'] as String?,
      json['isExpanded'] as bool?,
      DUIStyleClass.fromJson(json['styleClass']),
    );

Map<String, dynamic> _$DUIDropdownPropsToJson(DUIDropdownProps instance) =>
    <String, dynamic>{
      'borderRadius': instance.borderRadius,
      'alignment': instance.alignment,
      'dropdownColor': instance.dropdownColor,
      'focusColor': instance.focusColor,
      'isExpanded': instance.isExpanded,
    };
