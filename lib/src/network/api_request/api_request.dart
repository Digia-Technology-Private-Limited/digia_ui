import 'package:json_annotation/json_annotation.dart';

import '../../models/variable_def.dart';
import '../core/types.dart';

part 'api_request.g.dart';

@JsonSerializable()
class APIModel {
  final String id;
  final String url;
  final HttpMethod method;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? body;
  @VariablesJsonConverter()
  Map<String, VariableDef>? variables;

  APIModel({
    required this.id,
    required this.url,
    required this.method,
    required this.headers,
    required this.body,
    this.variables,
  });

  factory APIModel.fromJson(Map<String, dynamic> json) =>
      _$APIModelFromJson(json);

  Map<String, dynamic> toJson() => _$APIModelToJson(this);
}
