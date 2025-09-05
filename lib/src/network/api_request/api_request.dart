import 'package:json_annotation/json_annotation.dart';

import '../../framework/data_type/variable.dart';
import '../../framework/data_type/variable_json_converter.dart';
import '../../framework/utils/types.dart';
import '../core/types.dart';

part 'api_request.g.dart';

@JsonSerializable()
class APIModel {
  final String id;
  final String name;
  final String url;
  final HttpMethod method;
  final JsonLike? headers;
  final JsonLike? body;
  final BodyType? bodyType;
  @VariableJsonConverter()
  Map<String, Variable>? variables;

  APIModel({
    required this.id,
    required this.name,
    required this.url,
    required this.method,
    required this.headers,
    required this.body,
    required this.bodyType,
    this.variables,
  });

  factory APIModel.fromJson(Map<String, dynamic> json) =>
      _$APIModelFromJson(json);

  Map<String, dynamic> toJson() => _$APIModelToJson(this);
}
