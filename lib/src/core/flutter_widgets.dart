import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/app_bar/app_bar.props.dart';
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

  static AppBar appBar(Map<String, dynamic> json) {
    final props = DUIAppBarProps.fromJson(json);

    return AppBar(
        title: DUIText(props.title),
        elevation: props.elevation,
        shadowColor: props.shadowColor.letIfTrue(toColor),
        backgroundColor: props.backgrounColor.letIfTrue(toColor),
        iconTheme: IconThemeData(color: props.iconColor.letIfTrue(toColor)));
  }
}
