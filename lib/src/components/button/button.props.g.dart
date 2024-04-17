// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonProps _$DUIButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIButtonProps()
      ..styleClass = DUIButtonStyleClass.fromJson(json['style'])
      ..text = DUITextProps.fromJson(json['text'])
      ..rightIcon = json['rightIcon'] == null
          ? null
          : DUIIconProps.fromJson(json['rightIcon'])
      ..leftIcon = json['leftIcon'] == null
          ? null
          : DUIIconProps.fromJson(json['leftIcon'])
      ..disabled = json['disabled'] as bool?
      ..onClick =
          json['onClick'] == null ? null : ActionFlow.fromJson(json['onClick']);

Map<String, dynamic> _$DUIButtonPropsToJson(DUIButtonProps instance) =>
    <String, dynamic>{
      'text': instance.text,
      'rightIcon': instance.rightIcon,
      'leftIcon': instance.leftIcon,
      'disabled': instance.disabled,
      'onClick': instance.onClick,
    };
