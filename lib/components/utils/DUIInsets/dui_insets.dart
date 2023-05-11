import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dui_insets.g.dart';

@JsonSerializable()
class DUIInsets {
  late String? top;
  late String? bottom;
  late String? left;
  late String? right;

  DUIInsets();

  factory DUIInsets.fromJson(Map<String, dynamic> json) =>
      _$DUIInsetsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIInsetsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
