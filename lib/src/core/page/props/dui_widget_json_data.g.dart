// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_widget_json_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIWidgetJsonData _$DUIWidgetJsonDataFromJson(Map<String, dynamic> json) =>
    DUIWidgetJsonData(
      id: json['id'] as String?,
      type: json['type'] as String,
      props: json['props'] as Map<String, dynamic>?,
      containerProps: json['containerProps'] as Map<String, dynamic>?,
      children: DUIWidgetJsonData._childrenFromJson(json['children']),
    );

Map<String, dynamic> _$DUIWidgetJsonDataToJson(DUIWidgetJsonData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'children': instance.children,
      'props': instance.props,
      'containerProps': instance.containerProps,
    };
