import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  bool? isSuccess;
  T? data;
  Map<String, dynamic>? error;

  BaseResponse({this.isSuccess, this.data, this.error});

  factory BaseResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseFromJson(json, fromJsonT);

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) =>
      _$BaseResponseToJson(this, toJsonT);
}
