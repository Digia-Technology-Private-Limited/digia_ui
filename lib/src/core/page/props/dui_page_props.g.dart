// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIPageProps _$DUIPagePropsFromJson(Map<String, dynamic> json) => DUIPageProps(
      uid: json['uid'] as String,
      actions: json['actions'],
      inputArgs: json['inputArgs'],
      variables: _$JsonConverterFromJson<Map<String, dynamic>,
              Map<String, VariableDef>>(
          json['variables'], const VariablesJsonConverter().fromJson),
      layout: const PageLayoutJsonConverter()
          .fromJson(json['layout'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$DUIPagePropsToJson(DUIPageProps instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'actions': instance.actions,
      'inputArgs': instance.inputArgs,
      'variables':
          _$JsonConverterToJson<Map<String, dynamic>, Map<String, VariableDef>>(
              instance.variables, const VariablesJsonConverter().toJson),
      'layout': const PageLayoutJsonConverter().toJson(instance.layout),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

PageBody _$PageBodyFromJson(Map<String, dynamic> json) => PageBody(
      root: DUIWidgetJsonData.fromJson(json['root'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageBodyToJson(PageBody instance) => <String, dynamic>{
      'root': instance.root,
    };
