import 'package:digia_ui/Utils/basic_shared_utils/num_decoder.dart';
import 'package:flutter/material.dart';

class FW {
  static SizedBox sizedBox(Map<String, dynamic> json) {
    final width = NumDecoder.toDouble(json['width']);
    final height = NumDecoder.toDouble(json['height']);
    return SizedBox(
      width: width,
      height: height,
    );
  }

  // This does not work well directly inside a Container.
  // Avoid using it with styleClass.
  static Widget spacer(Map<String, dynamic>? json) {
    final flex = NumDecoder.toInt(json?['flex']) ?? 1;
    return Spacer(flex: flex);
  }
}
