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
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => DUIWidgetJsonData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DUIWidgetJsonDataToJson(DUIWidgetJsonData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'props': instance.props,
      'containerProps': instance.containerProps,
      'children': instance.children,
    };
