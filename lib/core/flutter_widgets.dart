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

// TODO: Spacer not working inside Column. To be fixed.
  static Widget spacer(Map<String, dynamic>? json) {
    // final flex = tryParseToInt(json?['flex']) ?? 1;
    // return SizedBox.expand();
    return Expanded(
        child: Container(
      height: 100,
    ));
  }
}
