// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_tab_controller_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DuiTabControllerProps _$DuiTabControllerPropsFromJson(
        Map<String, dynamic> json) =>
    DuiTabControllerProps(
      dynamicList: json['dynamicList'],
      animationDuration: (json['animationDuration'] as num?)?.toDouble(),
      initialIndex: json['initialIndex'],
    );

Map<String, dynamic> _$DuiTabControllerPropsToJson(
        DuiTabControllerProps instance) =>
    <String, dynamic>{
      'initialIndex': instance.initialIndex,
      'dynamicList': instance.dynamicList,
      'animationDuration': instance.animationDuration,
    };
