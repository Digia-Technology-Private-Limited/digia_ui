import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_corner_radius_props.g.dart';

@JsonSerializable()
class DUICornerRadius {
  double bottomLeft = 0;
  double bottomRight = 0;
  double topLeft = 0;
  double topRight = 0;

  DUICornerRadius();

  factory DUICornerRadius.fromJson(Map<String, dynamic> json) =>
      _$DUICornerRadiusFromJson(json);

  Map<String, dynamic> toJson() => _$DUICornerRadiusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  BorderRadiusGeometry getRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft),
      topRight: Radius.circular(topRight),
      bottomLeft: Radius.circular(bottomLeft),
      bottomRight: Radius.circular(bottomRight),
    );
  }
}
