import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_corner_radius.g.dart';

@JsonSerializable()
class DUICornerRadius {
  late double bottomLeft = 0;
  late double bottomRight = 0;
  late double topLeft = 0;
  late double topRight = 0;

  DUICornerRadius();

  factory DUICornerRadius.fromJson(Map<String, dynamic> json) =>
      _$DUICornerRadiusFromJson(json);

  Map<String, dynamic> toJson() => _$DUICornerRadiusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  BorderRadiusGeometry getCornerRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }
}
