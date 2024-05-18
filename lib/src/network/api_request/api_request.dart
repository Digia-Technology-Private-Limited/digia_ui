import 'package:json_annotation/json_annotation.dart';

import '../core/types.dart';

part 'api_request.g.dart';

@JsonSerializable()
class APIModel {
  final String id;
  final String url;
  final HttpMethod method;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? variables;

  APIModel({
    required this.id,
    required this.url,
    required this.method,
    required this.headers,
    required this.body,
    required this.variables,
  });

  factory APIModel.fromJson(Map<String, dynamic> json) =>
      _$APIModelFromJson(json);

  Map<String, dynamic> toJson() => _$APIModelToJson(this);
}
