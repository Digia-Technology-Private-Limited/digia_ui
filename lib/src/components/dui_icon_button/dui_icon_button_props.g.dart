// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_icon_button_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIIconButtonProps _$DUIIconButtonPropsFromJson(Map<String, dynamic> json) =>
    DUIIconButtonProps(
      icon: json['icon'] == null ? null : DUIIconProps.fromJson(json['icon']),
      onClick: json['onClick'] == null
          ? null
          : ActionProp.fromJson(json['onClick'] as Map<String, dynamic>),
      iconColor: json['iconColor'] as String?,
      iconSize: (json['iconSize'] as num?)?.toDouble(),
      padding:
          json['padding'] == null ? null : DUIInsets.fromJson(json['padding']),
      alignment: json['alignment'] as String?,
      childAlignment: json['childAlignment'] as String?,
      backgroundColor: json['backgroundColor'] as String?,
      elevation: (json['elevation'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DUIIconButtonPropsToJson(DUIIconButtonProps instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'iconColor': instance.iconColor,
      'iconSize': instance.iconSize,
      'padding': instance.padding,
      'alignment': instance.alignment,
      'onClick': instance.onClick,
      'childAlignment': instance.childAlignment,
      'elevation': instance.elevation,
      'backgroundColor': instance.backgroundColor,
    };
