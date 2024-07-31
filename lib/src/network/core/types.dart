import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum HttpMethod {
  @JsonValue('GET')
  get,
  @JsonValue('POST')
  post,
  @JsonValue('PUT')
  put,
  @JsonValue('DELETE')
  delete,
  @JsonValue('PATCH')
  patch
}

extension HttpMethodProperties on HttpMethod {
  String get stringValue {
    switch (this) {
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.delete:
        return 'DELETE';
      case HttpMethod.patch:
        return 'PATCH';
    }
  }
}

@JsonEnum()
enum BodyType {
  @JsonValue('JSON')
  json,
  @JsonValue('MULTIPART')
  multipart
}

extension BodyTypeProperties on BodyType {
  String get stringValue {
    switch (this) {
      case BodyType.json:
        return 'JSON';
      case BodyType.multipart:
        return 'MULTIPART';
    }
  }
}
