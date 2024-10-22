import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../../framework/utils/functional_util.dart';
import '../DUIText/dui_text.dart';
import '../dui_icons/icon_helpers/icon_data_serialization.dart';
import 'floating_action_button_props.dart';

class DUIFloatingActionButton {
  static FloatingActionButton floatingActionButton(
      Map<String, dynamic> json, BuildContext context, DUIWidgetJsonData data) {
    final props = DUIFloatingActionButtonProps.fromJson(json);
    return FloatingActionButton.extended(
        shape: props.shape == null ? null : toButtonShape(props.shape),
        backgroundColor: props.bgColor.letIfTrue(toColor),
        enableFeedback: props.enableFeedback,
        elevation: props.elevation,
        foregroundColor: props.fgColor.letIfTrue(toColor),
        splashColor: props.splashColor.letIfTrue(toColor),
        isExtended: props.isExtended == true ? true : false,
        onPressed: () {
          final onClick = ActionFlow.fromJson(json['onClick']);
          ActionHandler.instance.execute(context: context, actionFlow: onClick);
        },
        label: Row(
          children: [
            Visibility(
              visible: props.leadingIcon?['iconData'] != null,
              child: Icon(
                getIconData(
                  icondataMap: as$<Map<String, dynamic>>(
                          props.leadingIcon?['iconData']) ??
                      {},
                ),
              ),
            ),
            SizedBox(
              width: props.leadingIcon?['iconData'] != null &&
                      json['buttonText']?['text'] != null
                  ? props.extendedIconLabelSpacing
                  : 0,
            ),
            Visibility(
                visible: json['buttonText']?['text'] != null,
                child: props.buttonText != null
                    ? DUIText(props.buttonText!)
                    : const SizedBox.shrink()),
            SizedBox(
              width: props.trailingIcon?['iconData'] != null &&
                      json['buttonText']?['text'] != null
                  ? props.extendedIconLabelSpacing
                  : 0,
            ),
            Visibility(
              visible: props.trailingIcon?['iconData'] != null,
              child: Icon(
                getIconData(
                  icondataMap: as$<Map<String, dynamic>>(
                          props.trailingIcon?['iconData']) ??
                      {},
                ),
              ),
            )
          ],
        ));
  }
}

class DUIFloatingActionButtonLocation {
  static FloatingActionButtonLocation fabLocation(
      DUIFloatingActionButtonProps? props) {
    FloatingActionButtonLocation fabLoc;
    switch (props?.location) {
      case 'centerFloat':
        fabLoc = FloatingActionButtonLocation.centerFloat;
        break;
      case 'centerDocked':
        fabLoc = FloatingActionButtonLocation.centerDocked;
        break;
      case 'endFloat':
        fabLoc = FloatingActionButtonLocation.endFloat;
        break;
      default:
        fabLoc = FloatingActionButtonLocation.endFloat;
        break;
    }
    return fabLoc;
  }
}
