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
  late String? style;
  late String? url;

  DUITextSpan();

  factory DUITextSpan.fromJson(Map<String, dynamic> json) =>
      _$DUITextSpanFromJson(json);

  Map<String, dynamic> toJson() => _$DUITextSpanToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  TextSpan getSpan() {
    return TextSpan(
      text: text,
      style: getTextStyle(style: style ?? DUIConfigConstants.fallbackStyle),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
          //todo change onTap functionality according to backend latter
          if (url != null) {
            if (await canLaunchUrl(Uri.parse(url!))) {
              await launchUrl(Uri.parse(url!));
            } else {
              null;
            }
          } else {
            null;
          }
        },
    );
  }
}
