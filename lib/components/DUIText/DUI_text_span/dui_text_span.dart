import 'dart:convert';

import 'package:digia_ui/Utils/color_extension.dart';
import 'package:digia_ui/components/DUIText/Dui_font_weight/dui_font_weight.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'dui_text_span.g.dart';

@JsonSerializable()
class DUITextSpan {
  late String text;
  late DUIFontWeight? fontWeight;
  late String? color;
  late double? fontSize;
  late bool? isUnderlined;
  late bool? isItalic;
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
      style: TextStyle(
          fontWeight: fontWeight?.getFontWeight() ?? FontWeight.w400,
          color: color?.toColor() ?? Colors.black,
          fontSize: fontSize,
          decoration: (isUnderlined ?? false)
              ? TextDecoration.underline
              : TextDecoration.none,
          fontStyle: (isItalic ?? false) ? FontStyle.italic : FontStyle.normal),
      recognizer: TapGestureRecognizer()
        ..onTap = () async {
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
