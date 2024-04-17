// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_icon_button_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIIconButtonProps _$DUIIconButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIIconButtonProps(
      styleClass: DUIButtonStyleClass.fromJson(json['String']),
      icon: json['icon'] == null ? null : DUIIconProps.fromJson(json['icon']),
      onClick:
          json['onClick'] == null ? null : ActionFlow.fromJson(json['onClick']),
      childAlignment: json['childAlignment'] as String?,
      elevation: (json['elevation'] as num?)?.toDouble(),
      backgroundColor: json['backgroundColor'] as String?,
    );

Map<String, dynamic> _$DUIIconButtonPropsToJson(DUIIconButtonProps instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'onClick': instance.onClick,
      'childAlignment': instance.childAlignment,
      'elevation': instance.elevation,
      'backgroundColor': instance.backgroundColor,
    };
