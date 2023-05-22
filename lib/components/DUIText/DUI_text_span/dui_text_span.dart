import 'dart:convert';

import 'package:digia_ui/Utils/util_functions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'dui_text_span.g.dart';

@JsonSerializable()
class DUITextSpan {
  late String text;
  late String? styleClass;
  late String? url;

  DUITextSpan();

  factory DUITextSpan.fromJson(Map<String, dynamic> json) =>
      _$DUITextSpanFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextSpanToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
