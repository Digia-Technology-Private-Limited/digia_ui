// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linear_progress_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUILinearProgressProps _$DUILinearProgressPropsFromJson(
        Map<String, dynamic> json) =>
    DUILinearProgressProps(
      width: (json['width'] as num?)?.toDouble(),
      minHeight: (json['minHeight'] as num?)?.toDouble(),
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
      bgColor: json['bgColor'] as String?,
      indicatorColor: json['indicatorColor'] as String?,
      animationDuration: json['animationDuration'] as int?,
      animationBeginLength: (json['animationBeginLength'] as num?)?.toDouble(),
      animationEndLength: (json['animationEndLength'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUILinearProgressPropsToJson(
        DUILinearProgressProps instance) =>
    <String, dynamic>{
      'width': instance.width,
      'minHeight': instance.minHeight,
      'borderRadius': instance.borderRadius,
      'bgColor': instance.bgColor,
      'indicatorColor': instance.indicatorColor,
      'animationDuration': instance.animationDuration,
      'animationBeginLength': instance.animationBeginLength,
      'animationEndLength': instance.animationEndLength,
    };
