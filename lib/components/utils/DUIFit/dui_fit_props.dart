import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_fit_props.g.dart';

@JsonSerializable()
class DUIFit {
  String fit = 'none';

  DUIFit();

  factory DUIFit.fromJson(Map<String, dynamic> json) =>
      _$DUIFitFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFitToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  BoxFit fitImage() {
    if (fit == 'fill') {
      return BoxFit.fill;
    } else if (fit == 'contain') {
      return BoxFit.contain;
    } else if (fit == 'cover') {
      return BoxFit.cover;
    } else if (fit == 'fitWidth') {
      return BoxFit.fitWidth;
    } else if (fit == 'fitHeight') {
      return BoxFit.fitHeight;
    } else if (fit == 'scaleDown') {
      return BoxFit.scaleDown;
    } else {
      return BoxFit.none;
    }
  }
}
