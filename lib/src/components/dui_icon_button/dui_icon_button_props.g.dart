// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_icon_button_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIIconButtonProps _$DUIIconButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIIconButtonProps()
      ..styleClass = DUIButtonStyleClass.fromJson(json['String'])
      ..disabledButtonStyle = DUIDisabledButtonStyle.fromJson(
          json['disabledButtonStyle'] as Map<String, dynamic>)
      ..icon = json['icon'] == null ? null : DUIIconProps.fromJson(json['icon'])
      ..onClick =
          json['onClick'] == null ? null : ActionFlow.fromJson(json['onClick']);

Map<String, dynamic> _$DUIIconButtonPropsToJson(DUIIconButtonProps instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'onClick': instance.onClick,
    };
