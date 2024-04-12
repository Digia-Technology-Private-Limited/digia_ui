// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

APIModel _$APIModelFromJson(Map<String, dynamic> json) => APIModel(
      json['variables'] as Map<String, dynamic>,
      json['headers'] as Map<String, dynamic>,
      json['body'] as Map<String, dynamic>,
      apiName: json['apiName'] as String,
      apiUrl: json['apiUrl'] as String,
      httpMethod: $enumDecode(_$HttpMethodEnumMap, json['httpMethod']),
    );

Map<String, dynamic> _$APIModelToJson(APIModel instance) => <String, dynamic>{
      'apiName': instance.apiName,
      'apiUrl': instance.apiUrl,
      'httpMethod': _$HttpMethodEnumMap[instance.httpMethod]!,
      'headers': instance.headers,
      'body': instance.body,
      'variables': instance.variables,
    };

const _$HttpMethodEnumMap = {
  HttpMethod.get: 'GET',
  HttpMethod.post: 'POST',
  HttpMethod.put: 'PUT',
  HttpMethod.delete: 'DELETE',
  HttpMethod.patch: 'PATCH',
};
