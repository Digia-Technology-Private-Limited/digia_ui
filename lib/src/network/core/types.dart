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
  multipart,
  @JsonValue('FORM_URLENCODED')
  formUrlEncoded, // New enum value
}

extension BodyTypeProperties on BodyType {
  String get stringValue {
    switch (this) {
      case BodyType.json:
        return 'JSON';
      case BodyType.multipart:
        return 'MULTIPART';
      case BodyType.formUrlEncoded:
        return 'FORM_URLENCODED'; // New case
    }
  }

  // Helper method to get the appropriate content type header
  String? get contentTypeHeader {
    switch (this) {
      case BodyType.json:
        return 'application/json';
      case BodyType.multipart:
        return 'multipart/form-data';
      case BodyType.formUrlEncoded:
        return 'application/x-www-form-urlencoded';
    }
  }
}
