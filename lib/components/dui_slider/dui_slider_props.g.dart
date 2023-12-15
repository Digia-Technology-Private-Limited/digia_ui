// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_slider_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUISliderProps _$DUISliderPropsFromJson(Map<String, dynamic> json) =>
    DUISliderProps(
      enabled: json['enabled'] as bool?,
      minVal: (json['minVal'] as num?)?.toDouble(),
      maxVal: (json['maxVal'] as num?)?.toDouble(),
      divisions: json['divisions'] as int?,
      width: (json['width'] as num?)?.toDouble(),
      activeColor: json['activeColor'] as String?,
      inactiveColor: json['inactiveColor'] as String?,
      thumbColor: json['thumbColor'] as String?,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$DUISliderPropsToJson(DUISliderProps instance) =>
    <String, dynamic>{
      'value': instance.value,
      'enabled': instance.enabled,
      'minVal': instance.minVal,
      'maxVal': instance.maxVal,
      'divisions': instance.divisions,
      'width': instance.width,
      'activeColor': instance.activeColor,
      'inactiveColor': instance.inactiveColor,
      'thumbColor': instance.thumbColor,
    };
