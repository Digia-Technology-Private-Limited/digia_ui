// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dui_component_props.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DUIComponentProps _$DUIComponentPropsFromJson(Map<String, dynamic> json) =>
    DUIComponentProps(
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
          : ComponentLayoutProps.fromJson(
              json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DUIComponentPropsToJson(DUIComponentProps instance) =>
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

ComponentLayoutProps _$ComponentLayoutPropsFromJson(
        Map<String, dynamic> json) =>
    ComponentLayoutProps(
      root: VWNodeData.fromJson(json['root'] as Map<String, dynamic>),
    );
