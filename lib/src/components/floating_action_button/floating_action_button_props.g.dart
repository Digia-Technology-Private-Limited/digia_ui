// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floating_action_button_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIFloatingActionButtonProps _$DUIFloatingActionButtonPropsFromJson(
        Map<String, dynamic> json) =>
    DUIFloatingActionButtonProps(
      buttonText: json['buttonText'] == null
          ? null
          : DUITextProps.fromJson(json['buttonText']),
      leadingIcon: json['leadingIcon'] as Map<String, dynamic>?,
      trailingIcon: json['trailingIcon'] as Map<String, dynamic>?,
      shape: json['shape'] as String?,
      location: json['location'] as String?,
      extendedIconLabelSpacing:
          (json['extendedIconLabelSpacing'] as num?)?.toDouble(),
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
      'buttonText': instance.buttonText,
      'leadingIcon': instance.leadingIcon,
      'trailingIcon': instance.trailingIcon,
      'shape': instance.shape,
      'location': instance.location,
      'extendedIconLabelSpacing': instance.extendedIconLabelSpacing,
      'bgColor': instance.bgColor,
      'enableFeedback': instance.enableFeedback,
      'elevation': instance.elevation,
      'fgColor': instance.fgColor,
      'splashColor': instance.splashColor,
      'onClick': instance.onClick,
      'isExtended': instance.isExtended,
    };
