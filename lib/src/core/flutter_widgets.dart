import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/app_bar/app_bar.props.dart';
import 'package:digia_ui/src/components/dui_icons/icon_helpers/icon_data_serialization.dart';
import 'package:digia_ui/src/components/floating_action_button/floating_action_button_props.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  static FloatingActionButton floatingActionButton(
      Map<String, dynamic> json, BuildContext context) {
    final bloc = context.read<DUIPageBloc>();
    final props = DUIFloatingActionButtonProps.fromJson(json);
    return FloatingActionButton(
        backgroundColor: props.bgColor.letIfTrue(toColor),
        enableFeedback: props.enableFeedback,
        elevation: props.elevation,
        foregroundColor: props.fgColor.letIfTrue(toColor),
        splashColor: props.splashColor.letIfTrue(toColor),
        isExtended: props.isExtended == true ? true : false,
        onPressed: () {
          bloc.add(PostActionEvent(action: props.onClick!, context: context));
        },
        child: Icon(getIconData(
            icondataMap: props.icon?['iconData'] ??
                {'pack': 'material', 'key': 'add'})));
  }
}
