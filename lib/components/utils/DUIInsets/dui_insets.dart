import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dui_insets.g.dart';

@JsonSerializable()
class DUIInsets {
  String top;
  String bottom;
  String left;
  String right;

  DUIInsets(
      {this.top = "0", this.bottom = "0", this.left = "0", this.right = "0"});

  factory DUIInsets.fromJson(Map<String, dynamic> json) =>
      _$DUIInsetsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIInsetsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
