import 'package:digia_ui/src/Utils/basic_shared_utils/dui_decoder.dart';
import 'package:digia_ui/src/Utils/basic_shared_utils/lodash.dart';
import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/DUIText/DUI_text_span/dui_text_span.dart';
import 'package:digia_ui/src/components/DUIText/dui_text.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';
import 'package:digia_ui/src/components/dui_icons/dui_icon.dart';
import 'package:digia_ui/src/core/action/action_handler.dart';
import 'package:flutter/material.dart';

import 'button.props.dart';

class DUIButton extends StatefulWidget {
  final DUIButtonProps props;

  // TODO: GLobalKey is needed for different shapes, but that causes
  // interference with DUIButton.create function which is needed
  // to render from json.
  // final GlobalKey globalKey = GlobalKey();
  const DUIButton(this.props, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _DUIButtonState();
}

class _DUIButtonState extends State<DUIButton> {
  late DUIButtonProps props;
  late RenderBox renderbox;
  double width = 0;
  double height = 0;

  _DUIButtonState();

  @override
  void initState() {
    super.initState();
    props = widget.props;
  }

  // TODO: We may need to use Plain text here and not rich text.
  // Problem is we need we may need to change textColor in case of disabled state.
  // We would need to fetch a new textStyleClass for disabled state.
  // Not supporting it for now.
  @override
  Widget build(BuildContext context) {
    MaterialStatesController controller = MaterialStatesController();
    DUITextStyle disabledTextStyle = widget.props.text.textStyle != null
        ? widget.props.text.textStyle!.copyWith(
            textColor: (widget.props.disabledButtonStyle != null &&
                    (widget.props.disabledButtonStyle!.isDisabled))
                ? widget.props.disabledButtonStyle?.disabledChildColor
                : null,
          )
        : DUITextStyle(
            textColor: (widget.props.disabledButtonStyle != null &&
                    (widget.props.disabledButtonStyle!.isDisabled))
                ? widget.props.disabledButtonStyle?.disabledChildColor
                : null);
    Widget child = (widget.props.leftIcon != null ||
            widget.props.rightIcon != null)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (widget.props.leftIcon != null)
                  ? DUIIcon(
                      widget.props.leftIcon!.copyWith(
                        iconColor: (widget.props.disabledButtonStyle != null &&
                                widget.props.disabledButtonStyle!.isDisabled)
                            ? widget
                                .props.disabledButtonStyle?.disabledChildColor
                            : null,
                      ),
                    )
                  : const SizedBox.shrink(),
              DUIText(
                widget.props.text.copyWith(
                  textSpans: [DUITextSpan(text: 'Button')],
                  textStyle: disabledTextStyle,
                ),
              ),
              (widget.props.rightIcon != null)
                  ? DUIIcon(
                      widget.props.rightIcon!.copyWith(
                        iconColor: (widget.props.disabledButtonStyle != null &&
                                widget.props.disabledButtonStyle!.isDisabled)
                            ? widget
                                .props.disabledButtonStyle?.disabledChildColor
                            : null,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          )
        : DUIText(
            widget.props.text.copyWith(
              textStyle: disabledTextStyle,
            ),
          );

    ButtonStyle style = ButtonStyle(
      shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
        (states) => (widget.props.styleClass != null &&
                widget.props.styleClass!.shape != null)
            ? DUIDecoder.toButtonShape(widget.props.styleClass!.shape!)
            : RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
      ),
      padding: MaterialStatePropertyAll(
        DUIDecoder.toEdgeInsets(
          widget.props.styleClass?.padding?.toJson(),
        ),
      ),
      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      elevation: MaterialStatePropertyAll(widget.props.styleClass?.elevation),
      iconColor: MaterialStateProperty.resolveWith(
        (states) => widget.props.disabledButtonStyle?.disabledChildColor
            ?.letIfTrue(toColor),
      ),
      shadowColor: MaterialStatePropertyAll(
          widget.props.styleClass?.shadowColor.letIfTrue(toColor)),
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
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => (widget.props.disabledButtonStyle?.isDisabled ?? false)
            ? widget.props.disabledButtonStyle?.disabledChildColor
                .letIfTrue(toColor)
            : null,
      ),
    );

    return Padding(
      padding: DUIDecoder.toEdgeInsets(
        widget.props.styleClass?.margin?.toJson(),
      ),
      child: ElevatedButton(
        statesController: controller,
        onPressed: (widget.props.disabledButtonStyle?.isDisabled ?? false)
            ? () {}
            : props.onClick.let((p0) {
                return () => ActionHandler.instance
                    .execute(context: context, actionFlow: p0);
              }),
        style: style,
        child: child,
      ),
    );
  }
}
