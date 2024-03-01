// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_icon_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIIconProps _$DUIIconPropsFromJson(Map<String, dynamic> json) => DUIIconProps(
      iconSize: (json['iconSize'] as num?)?.toDouble(),
      iconColor: json['iconColor'] as String?,
      iconData: json['iconData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DUIIconPropsToJson(DUIIconProps instance) =>
    <String, dynamic>{
      'iconData': instance.iconData,
      'iconSize': instance.iconSize,
      'iconColor': instance.iconColor,
    };
