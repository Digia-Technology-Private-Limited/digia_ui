// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_circular_progress_indicator_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICircularProgressIndicatorProps _$DUICircularProgressIndicatorPropsFromJson(
        Map<String, dynamic> json) =>
    DUICircularProgressIndicatorProps(
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
      strokeAlign: (json['strokeAlign'] as num?)?.toDouble(),
      strokeCap: json['strokeCap'] as String?,
      thickness: (json['thickness'] as num?)?.toDouble(),
      bgColor: json['bgColor'] as String?,
      indicatorColor: json['indicatorColor'] as String?,
      animationDuration: json['animationDuration'] as int?,
      animationBeginLength: (json['animationBeginLength'] as num?)?.toDouble(),
      animationEndLength: (json['animationEndLength'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUICircularProgressIndicatorPropsToJson(
        DUICircularProgressIndicatorProps instance) =>
    <String, dynamic>{
      'strokeWidth': instance.strokeWidth,
      'strokeAlign': instance.strokeAlign,
      'thickness': instance.thickness,
      'strokeCap': instance.strokeCap,
      'bgColor': instance.bgColor,
      'indicatorColor': instance.indicatorColor,
      'animationDuration': instance.animationDuration,
      'animationBeginLength': instance.animationBeginLength,
      'animationEndLength': instance.animationEndLength,
    };
