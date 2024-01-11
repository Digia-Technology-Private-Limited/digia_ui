// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_slider_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUISliderProps _$DUISliderPropsFromJson(Map<String, dynamic> json) =>
    DUISliderProps(
      DUIStyleClass.fromJson(json['styleClass']),
      (json['value'] as num?)?.toDouble(),
      json['activeColor'] as String?,
      json['inactiveColor'] as String?,
      (json['min'] as num?)?.toDouble(),
      (json['max'] as num?)?.toDouble(),
      json['divisions'] as int?,
      json['thumbColor'] as String?,
    );

Map<String, dynamic> _$DUISliderPropsToJson(DUISliderProps instance) =>
    <String, dynamic>{
      'value': instance.value,
      'activeColor': instance.activeColor,
      'inactiveColor': instance.inactiveColor,
      'min': instance.min,
      'max': instance.max,
      'divisions': instance.divisions,
      'thumbColor': instance.thumbColor,
    };
