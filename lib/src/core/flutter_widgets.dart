import 'package:flutter/material.dart';

import '../Utils/basic_shared_utils/lodash.dart';
import '../Utils/basic_shared_utils/num_decoder.dart';
import '../Utils/util_functions.dart';
import '../components/DUIText/dui_text.dart';
import '../components/app_bar/app_bar.props.dart';

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

  static AppBar appBar(Map<String, dynamic> json) {
    final props = DUIAppBarProps.fromJson(json);

    return AppBar(
        title: props.title.let((p0) => DUIText(p0)),
        elevation: props.elevation,
        shadowColor: props.shadowColor.letIfTrue(toColor),
        backgroundColor: props.backgrounColor.letIfTrue(toColor),
        iconTheme: IconThemeData(color: props.iconColor.letIfTrue(toColor)));
  }
}
