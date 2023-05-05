import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_text_over_flow.g.dart';

@JsonSerializable()
class DUITextOverFlow {
  late String overFlow;

  DUITextOverFlow();

  factory DUITextOverFlow.fromJson(Map<String, dynamic> json) =>
      _$DUITextOverFlowFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextOverFlowToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  TextOverflow getOverFlow() {
    switch (overFlow) {
      case "fade":
        return TextOverflow.fade;
      case "visible":
        return TextOverflow.visible;
      case "clip":
        return TextOverflow.clip;
      default:
        return TextOverflow.ellipsis;
    }
  }
}
