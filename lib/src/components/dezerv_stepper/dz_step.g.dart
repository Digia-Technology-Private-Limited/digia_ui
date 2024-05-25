// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dz_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DZStep _$DZStepFromJson(Map<String, dynamic> json) => DZStep(
      title:
          json['title'] == null ? null : DUITextProps.fromJson(json['title']),
      subtitle: json['subtitle'] == null
          ? null
          : DUITextProps.fromJson(json['subtitle']),
      stepIcon: json['stepIcon'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DZStepToJson(DZStep instance) => <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'stepIcon': instance.stepIcon,
    };
