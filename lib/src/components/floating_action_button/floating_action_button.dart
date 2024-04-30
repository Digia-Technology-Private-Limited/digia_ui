import 'package:digia_ui/digia_ui.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/dui_icons/icon_helpers/icon_data_serialization.dart';
import 'package:digia_ui/src/components/floating_action_button/floating_action_button_props.dart';
import 'package:digia_ui/src/core/page/dui_page_bloc.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DUIFloatingActionButton {
  static FloatingActionButton floatingActionButton(
      Map<String, dynamic> json, BuildContext context, DUIWidgetJsonData data) {
    final bloc = context.read<DUIPageBloc>();
    final props = DUIFloatingActionButtonProps.fromJson(json);
    return FloatingActionButton.extended(
        backgroundColor: props.bgColor.letIfTrue(toColor),
        enableFeedback: props.enableFeedback,
        elevation: props.elevation,
        foregroundColor: props.fgColor.letIfTrue(toColor),
        splashColor: props.splashColor.letIfTrue(toColor),
        isExtended: props.isExtended == true ? true : false,
        onPressed: () {
          bloc.add(PostActionEvent(action: props.onClick!, context: context));
        },
        label: Row(
          children: [
            Visibility(
                visible: props.leadingIcon?['iconData'] != null,
                child: Icon(getIconData(
                    icondataMap: props.leadingIcon?['iconData'] ?? {}))),
            SizedBox(
              width: props.extendedIconLabelSpacing,
            ),
            Visibility(
                visible: props.buttonText != null,
                child: DUIText(props.buttonText!)),
            SizedBox(
              width: props.extendedIconLabelSpacing,
            ),
            Visibility(
                visible: props.trailingIcon?['iconData'] != null,
                child: Icon(getIconData(
                    icondataMap: props.trailingIcon?['iconData'] ?? {})))
          ],
        ));
  }
}
