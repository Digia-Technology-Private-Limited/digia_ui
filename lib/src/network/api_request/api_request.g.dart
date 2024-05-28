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
      // variables: json['variables'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$APIModelToJson(APIModel instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'method': _$HttpMethodEnumMap[instance.method]!,
      'headers': instance.headers,
      'body': instance.body,
      // 'variables': instance.variables,
    };

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'GET',
  HttpMethod.post: 'POST',
  HttpMethod.put: 'PUT',
  HttpMethod.delete: 'DELETE',
  HttpMethod.patch: 'PATCH',
};
