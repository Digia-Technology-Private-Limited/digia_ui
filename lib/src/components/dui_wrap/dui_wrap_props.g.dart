// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_wrap_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIWrapProps _$DUIWrapPropsFromJson(Map<String, dynamic> json) => DUIWrapProps(
      spacing: (json['spacing'] as num?)?.toDouble(),
      runSpacing: (json['runSpacing'] as num?)?.toDouble(),
      wrapAlignment: json['wrapAlignment'] as String?,
      wrapCrossAlignment: json['wrapCrossAlignment'] as String?,
      runAlignment: json['runAlignment'] as String?,
      direction: json['direction'] as String?,
      verticalDirection: json['verticalDirection'] as String?,
      clipBehavior: json['clipBehavior'] as String?,
    );

Map<String, dynamic> _$DUIWrapPropsToJson(DUIWrapProps instance) => <String, dynamic>{
      'spacing': instance.spacing,
      'runSpacing': instance.runSpacing,
      'wrapAlignment': instance.wrapAlignment,
      'wrapCrossAlignment': instance.wrapCrossAlignment,
      'runAlignment': instance.runAlignment,
      'direction': instance.direction,
      'verticalDirection': instance.verticalDirection,
      'clipBehavior': instance.clipBehavior,
    };
