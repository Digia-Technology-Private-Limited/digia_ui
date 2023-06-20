// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_form_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIFormProps _$DUIFormPropsFromJson(Map<String, dynamic> json) => DUIFormProps()
  ..children = (json['children'] as List<dynamic>)
      .map((e) => DUIFormChildProps.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$DUIFormPropsToJson(DUIFormProps instance) =>
    <String, dynamic>{
      'children': instance.children,
    };

DUIFormChildProps _$DUIFormChildPropsFromJson(Map<String, dynamic> json) =>
    DUIFormChildProps()
      ..type = json['type'] as String
      ..data = json['data'] as Map<String, dynamic>;

Map<String, dynamic> _$DUIFormChildPropsToJson(DUIFormChildProps instance) =>
    <String, dynamic>{
      'type': instance.type,
      'data': instance.data,
    };
