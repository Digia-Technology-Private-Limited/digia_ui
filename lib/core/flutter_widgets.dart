import 'package:digia_ui/Utils/util_functions.dart';
import 'package:flutter/material.dart';

class FW {
  static SizedBox sizedBox(Map<String, dynamic> json) {
    final width = tryParseToDouble(json['width']);
    final height = tryParseToDouble(json['height']);
    return SizedBox(
      width: width,
      height: height,
    );
  }

  // This does not work well directly inside a Container.
  // Avoid using it with styleClass.
  static Widget spacer(Map<String, dynamic>? json) {
    final flex = json?['flex'] as int? ?? 1;
    return Spacer(flex: flex);
  }
}
