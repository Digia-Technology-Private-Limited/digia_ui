// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linear_progress_bar_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUILinearProgressBarProps _$DUILinearProgressBarPropsFromJson(Map<String, dynamic> json) => DUILinearProgressBarProps(
      width: (json['width'] as num?)?.toDouble(),
      thickness: (json['thickness'] as num?)?.toDouble(),
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
      bgColor: json['bgColor'] as String?,
      indicatorColor: json['indicatorColor'] as String?,
      animationDuration: json['animationDuration'] as int?,
      animationBeginLength: (json['animationBeginLength'] as num?)?.toDouble(),
      animationEndLength: (json['animationEndLength'] as num?)?.toDouble(),
      curve: json['curve'] as String?,
    );

Map<String, dynamic> _$DUILinearProgressBarPropsToJson(DUILinearProgressBarProps instance) => <String, dynamic>{
      'width': instance.width,
      'thickness': instance.thickness,
      'borderRadius': instance.borderRadius,
      'bgColor': instance.bgColor,
      'indicatorColor': instance.indicatorColor,
      'animationDuration': instance.animationDuration,
      'animationBeginLength': instance.animationBeginLength,
      'animationEndLength': instance.animationEndLength,
      'curve': instance.curve,
    };
