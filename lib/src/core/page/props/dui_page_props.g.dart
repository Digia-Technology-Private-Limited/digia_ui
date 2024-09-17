// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_page_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIPageProps _$DUIPagePropsFromJson(Map<String, dynamic> json) => DUIPageProps(
      uid: json['uid'] as String,
      actions: (json['actions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, ActionFlow.fromJson(e)),
      ),
      inputArgs: _$JsonConverterFromJson<Map<String, dynamic>,
              Map<String, VariableDef>>(
          json['inputArgs'], const VariablesJsonConverter().fromJson),
      variables: _$JsonConverterFromJson<Map<String, dynamic>,
              Map<String, VariableDef>>(
          json['variables'], const VariablesJsonConverter().fromJson),
      layout: json['layout'] == null
          ? null
          : PageLayoutProps.fromJson(json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DUIPagePropsToJson(DUIPageProps instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'actions': instance.actions,
      'inputArgs':
          _$JsonConverterToJson<Map<String, dynamic>, Map<String, VariableDef>>(
              instance.inputArgs, const VariablesJsonConverter().toJson),
      'variables':
          _$JsonConverterToJson<Map<String, dynamic>, Map<String, VariableDef>>(
              instance.variables, const VariablesJsonConverter().toJson),
      'layout': instance.layout,
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

PageLayoutProps _$PageLayoutPropsFromJson(Map<String, dynamic> json) =>
    PageLayoutProps(
      root: VWNodeData.fromJson(json['root'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PageLayoutPropsToJson(PageLayoutProps instance) =>
    <String, dynamic>{
      'root': instance.root,
    };
