// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dezerv_stepper_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DezervStepperProps _$DezervStepperPropsFromJson(Map<String, dynamic> json) =>
    DezervStepperProps(
      currentIndex: (json['currentIndex'] as num?)?.toDouble(),
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => DZStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      showActiveState: json['showActiveState'] as bool?,
      iconRadius: (json['iconRadius'] as num?)?.toDouble(),
      sidePadding: (json['sidePadding'] as num?)?.toDouble(),
      firstTitleWidth: (json['firstTitleWidth'] as num?)?.toDouble(),
      lastTitleWidth: (json['lastTitleWidth'] as num?)?.toDouble(),
      circleColor: json['circleColor'] as String?,
    );

Map<String, dynamic> _$DezervStepperPropsToJson(DezervStepperProps instance) =>
    <String, dynamic>{
      'currentIndex': instance.currentIndex,
      'steps': instance.steps,
      'showActiveState': instance.showActiveState,
      'sidePadding': instance.sidePadding,
      'iconRadius': instance.iconRadius,
      'firstTitleWidth': instance.firstTitleWidth,
      'lastTitleWidth': instance.lastTitleWidth,
      'circleColor': instance.circleColor,
    };
