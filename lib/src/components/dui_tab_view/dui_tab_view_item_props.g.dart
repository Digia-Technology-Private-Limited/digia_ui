// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_view_item_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUITabViewItemProps _$DUITabViewItemPropsFromJson(Map<String, dynamic> json) =>
    DUITabViewItemProps(
      json['title'] == null ? null : DUITextProps.fromJson(json['title']),
      json['icon'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$DUITabViewItemPropsToJson(
        DUITabViewItemProps instance) =>
    <String, dynamic>{
      'title': instance.title,
      'icon': instance.icon,
    };
