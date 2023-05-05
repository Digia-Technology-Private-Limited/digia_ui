import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_alignment.g.dart';

@JsonSerializable()
class DUITextAlignment {
  late String alignment;

  DUITextAlignment();

  factory DUITextAlignment.fromJson(Map<String, dynamic> json) =>
      _$DUITextAlignmentFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextAlignmentToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  TextAlign getTextAlign() {
    switch (alignment) {
      case 'right':
        return TextAlign.right;
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'end':
        return TextAlign.end;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.start;
    }
  }
}
