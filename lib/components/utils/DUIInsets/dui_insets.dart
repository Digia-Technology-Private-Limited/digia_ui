import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_insets.g.dart';

@JsonSerializable()
class DUIInsets {
  late double top = 0;
  late double bottom = 0;
  late double left = 0;
  late double right = 0;

  DUIInsets();

  factory DUIInsets.fromJson(Map<String, dynamic> json) =>
      _$DUIInsetsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIInsetsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  EdgeInsetsGeometry margins() => EdgeInsets.fromLTRB(
        left,
        top,
        right,
        bottom,
      );
}
