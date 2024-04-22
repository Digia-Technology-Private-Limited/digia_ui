import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/dui_icon_button/dui_icon_button_props.dart';
import 'package:digia_ui/src/components/dui_icons/dui_icon.dart';
import 'package:digia_ui/src/components/dui_icons/dui_icon_props.dart';
import 'package:flutter/material.dart';

import '../../core/action/action_handler.dart';

class DUIIconButton extends StatefulWidget {
  final DUIIconButtonProps props;
  const DUIIconButton({required this.props, super.key});

  @override
  State<DUIIconButton> createState() => _DUIIconButtonState();
}

class _DUIIconButtonState extends State<DUIIconButton> {
  @override
  Widget build(BuildContext context) {
    Widget icon = DUIIcon(DUIIconProps.fromJson(widget.props.icon));
    MaterialStatesController controller = MaterialStatesController();
    ButtonStyle style = ButtonStyle(
      padding: MaterialStatePropertyAll(
        DUIDecoder.toEdgeInsets(
          widget.props.styleClass?.padding?.toJson(),
        ),
      ),
      alignment: DUIDecoder.toAlignment(widget.props.styleClass?.alignment),
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => (widget.props.disabledButtonStyle?.isDisabled ?? false)
            ? widget.props.disabledButtonStyle?.disabledBgColor
                .letIfTrue(toColor)
            : (controller.value.lastOrNull == MaterialState.pressed)
                ? widget.props.styleClass?.pressedBgColor.letIfTrue(toColor)
                : widget.props.styleClass?.bgColor.letIfTrue(toColor) ??
                    const Color(0xFF4945ff),
      ),
      iconColor: MaterialStateProperty.resolveWith(
        (states) => widget.props.disabledButtonStyle?.disabledChildColor
            ?.letIfTrue(toColor),
      ),
    );
    return IconButton(
      icon: icon,
      onPressed: (widget.props.disabledButtonStyle?.isDisabled ?? false)
          ? () {}
          : widget.props.onClick.let((p0) {
              return () => ActionHandler.instance
                  .execute(context: context, actionFlow: p0);
            }),
      style: style,
    );
  }
}
