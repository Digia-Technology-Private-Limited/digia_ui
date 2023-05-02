import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_fit.g.dart';

@JsonSerializable()
class DUIFit {
  late String fit = 'none';

  DUIFit();

  factory DUIFit.fromJson(Map<String, dynamic> json) =>
      _$DUIFitFromJson(json);

  Map<String, dynamic> toJson() => _$DUIFitToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  BoxFit fitImage() {
    switch(fit) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.none;
    }
  }
}
