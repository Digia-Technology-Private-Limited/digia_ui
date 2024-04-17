// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIButtonProps _$DUIButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIButtonProps()
      ..styleClass = DUIButtonStyleClass.fromJson(json['style'])
      ..disabledButtonStyle = DUIDisabledButtonStyle.fromJson(
          json['disabledButtonStyle'] as Map<String, dynamic>)
      ..text = DUITextProps.fromJson(json['text'])
      ..rightIcon = json['rightIcon'] == null
          ? null
          : DUIIconProps.fromJson(json['rightIcon'])
      ..leftIcon = json['leftIcon'] == null
          ? null
          : DUIIconProps.fromJson(json['leftIcon'])
      ..onClick =
          json['onClick'] == null ? null : ActionFlow.fromJson(json['onClick']);

Map<String, dynamic> _$DUIButtonPropsToJson(DUIButtonProps instance) =>
    <String, dynamic>{
      'text': instance.text,
      'rightIcon': instance.rightIcon,
      'leftIcon': instance.leftIcon,
      'onClick': instance.onClick,
    };
