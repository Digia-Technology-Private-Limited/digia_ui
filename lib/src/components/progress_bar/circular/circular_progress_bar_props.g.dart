// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circular_progress_bar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUICircularProgressBarProps _$DUICircularProgressBarPropsFromJson(
        Map<String, dynamic> json) =>
    DUICircularProgressBarProps(
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
      strokeAlign: (json['strokeAlign'] as num?)?.toDouble(),
      strokeCap: json['strokeCap'] as String?,
      thickness: (json['thickness'] as num?)?.toDouble(),
      bgColor: json['bgColor'] as String?,
      indicatorColor: json['indicatorColor'] as String?,
      animationDuration: json['animationDuration'] as int?,
      animationBeginLength: (json['animationBeginLength'] as num?)?.toDouble(),
      animationEndLength: (json['animationEndLength'] as num?)?.toDouble(),
      curve: json['curve'] as String?,
    );

Map<String, dynamic> _$DUICircularProgressBarPropsToJson(
        DUICircularProgressBarProps instance) =>
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
      'curve': instance.curve,
    };
