// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIModel _$APIModelFromJson(Map<String, dynamic> json) => APIModel(
  id: json['id'] as String,
  name: json['name'] as String?,
  url: json['url'] as String,
  method: $enumDecode(_$HttpMethodEnumMap, json['method']),
  headers: json['headers'] as Map<String, dynamic>?,
  body: json['body'] as Map<String, dynamic>?,
  bodyType: $enumDecodeNullable(_$BodyTypeEnumMap, json['bodyType']),
  variables:
      _$JsonConverterFromJson<Map<String, Object?>, Map<String, Variable>>(
        json['variables'],
        const VariableJsonConverter().fromJson,
      ),
);

Map<String, dynamic> _$APIModelToJson(APIModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'url': instance.url,
  'method': _$HttpMethodEnumMap[instance.method]!,
  'headers': instance.headers,
  'body': instance.body,
  'bodyType': _$BodyTypeEnumMap[instance.bodyType],
  'variables':
      _$JsonConverterToJson<Map<String, Object?>, Map<String, Variable>>(
        instance.variables,
        const VariableJsonConverter().toJson,
      ),
};

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'GET',
  HttpMethod.post: 'POST',
  HttpMethod.put: 'PUT',
  HttpMethod.delete: 'DELETE',
  HttpMethod.patch: 'PATCH',
};

const _$BodyTypeEnumMap = {
  BodyType.json: 'JSON',
  BodyType.multipart: 'MULTIPART',
  BodyType.formUrlEncoded: 'FORM_URLENCODED',
  BodyType.graphql: 'GRAPHQL',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
