// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floating_action_button_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIFloatingActionButtonProps _$DUIFloatingActionButtonPropsFromJson(
        Map<String, dynamic> json) =>
    DUIFloatingActionButtonProps(
      icon: json['icon'] as Map<String, dynamic>?,
      bgColor: json['bgColor'] as String?,
      enableFeedback: json['enableFeedback'] as bool?,
      elevation: (json['elevation'] as num?)?.toDouble(),
      fgColor: json['fgColor'] as String?,
      splashColor: json['splashColor'] as String?,
      onClick: json['onClick'] == null
          ? null
          : ActionProp.fromJson(json['onClick'] as Map<String, dynamic>),
      isExtended: json['isExtended'] as bool?,
    );

Map<String, dynamic> _$DUIFloatingActionButtonPropsToJson(
        DUIFloatingActionButtonProps instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'bgColor': instance.bgColor,
      'enableFeedback': instance.enableFeedback,
      'elevation': instance.elevation,
      'fgColor': instance.fgColor,
      'splashColor': instance.splashColor,
      'onClick': instance.onClick,
      'isExtended': instance.isExtended,
    };
