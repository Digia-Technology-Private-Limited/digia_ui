import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'dui_corner_radius.g.dart';

@JsonSerializable()
class DUICornerRadius {
  late double bottomLeft;
  late double bottomRight;
  late double topLeft;
  late double topRight;

  DUICornerRadius(
      {this.bottomLeft = 0,
      this.bottomRight = 0,
      this.topLeft = 0,
      this.topRight = 0});

  factory DUICornerRadius.fromJson(Map<String, dynamic> json) =>
      _$DUICornerRadiusFromJson(json);

  Map<String, dynamic> toJson() => _$DUICornerRadiusToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
