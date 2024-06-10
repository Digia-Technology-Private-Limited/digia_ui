// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIModel _$APIModelFromJson(Map<String, dynamic> json) => APIModel(
      id: json['id'] as String,
      url: json['url'] as String,
      method: $enumDecode(_$HttpMethodEnumMap, json['method']),
      headers: json['headers'] as Map<String, dynamic>?,
      body: json['body'] as Map<String, dynamic>?,
      variables: _$JsonConverterFromJson<Map<String, dynamic>,
              Map<String, VariableDef>>(
          json['variables'], const VariablesJsonConverter().fromJson),
    );

Map<String, dynamic> _$APIModelToJson(APIModel instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'method': _$HttpMethodEnumMap[instance.method]!,
      'headers': instance.headers,
      'body': instance.body,
      'variables':
          _$JsonConverterToJson<Map<String, dynamic>, Map<String, VariableDef>>(
              instance.variables, const VariablesJsonConverter().toJson),
    };

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'GET',
  HttpMethod.post: 'POST',
  HttpMethod.put: 'PUT',
  HttpMethod.delete: 'DELETE',
  HttpMethod.patch: 'PATCH',
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
