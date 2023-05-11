import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_corner_radius.g.dart';

@JsonSerializable()
class DUICornerRadius {
  late double? bottomLeft;
  late double? bottomRight;
  late double? topLeft;
  late double? topRight;

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
      topLeft: Radius.circular(topLeft ?? 0.0),
      topRight: Radius.circular(topRight ?? 0.0),
      bottomLeft: Radius.circular(bottomLeft ?? 0.0),
      bottomRight: Radius.circular(bottomRight ?? 0.0),
    );
  }
}
