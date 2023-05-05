import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'dui_font_weight.g.dart';

@JsonSerializable()
class DUIFontWeight {
  late int fontWeight;

  DUIFontWeight();

  factory DUIFontWeight.fromJson(Map<String, dynamic> json) =>
      _$DUIFontWeightFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFontWeightToJson(this);

  FontWeight getFontWeight() {
    switch (fontWeight) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700;
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        return FontWeight.w400;
    }
  }
}
