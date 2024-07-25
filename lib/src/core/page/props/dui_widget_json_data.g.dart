// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_widget_json_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIWidgetJsonData _$DUIWidgetJsonDataFromJson(Map<String, dynamic> json) =>
    DUIWidgetJsonData(
      type: json['type'] as String,
      props: json['props'] as Map<String, dynamic>?,
      containerProps: json['containerProps'] as Map<String, dynamic>?,
      children: DUIWidgetJsonData._childrenFromJson(json['children']),
      dataRef: json['dataRef'] as Map<String, dynamic>?,
      varName: json['varName'] as String?,
    );

Map<String, dynamic> _$DUIWidgetJsonDataToJson(DUIWidgetJsonData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'children': instance.children,
      'varName': instance.varName,
      'props': instance.props,
      'containerProps': instance.containerProps,
      'dataRef': instance.dataRef,
    };
