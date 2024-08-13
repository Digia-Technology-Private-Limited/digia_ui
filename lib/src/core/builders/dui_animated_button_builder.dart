import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_button_bounce_animation.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/props/dui_widget_json_data.dart';
import 'dui_icon_builder.dart';
import 'dui_text_builder.dart';

class DUIAnimatedButtonBuilder extends DUIWidgetBuilder {
  DUIAnimatedButtonBuilder({required super.data});

  static DUIAnimatedButtonBuilder create(DUIWidgetJsonData data) {
    return DUIAnimatedButtonBuilder(data: data);
  }

  factory DUIAnimatedButtonBuilder.fromProps(Map<String, dynamic> props) {
    return DUIAnimatedButtonBuilder(
      data: DUIWidgetJsonData(type: 'digia/animatedButton', props: props),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyleJson =
        data.props['defaultStyle'] as Map<String, dynamic>? ?? {};
    final disabledStyleJson =
        data.props['disabledStyle'] as Map<String, dynamic>? ?? {};

    ButtonStyle style = ButtonStyle(
        shape: WidgetStateProperty.all(toButtonShape(data.props['shape'])),
        padding: WidgetStateProperty.all(DUIDecoder.toEdgeInsets(
            defaultStyleJson['padding'],
            or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4))),
        elevation: WidgetStateProperty.all(
            NumDecoder.toDouble(defaultStyleJson['elevation'])),
        alignment: DUIDecoder.toAlignment(defaultStyleJson['alignment']),
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return ifNotNull(disabledStyleJson['backgroundColor'] as String?,
                (p0) => toColor(p0));
          }

          return ifNotNull(defaultStyleJson['backgroundColor'] as String?,
              (p0) => toColor(p0));
        }));

    final isDisabled = eval<bool>(data.props['isDisabled'], context: context) ??
        data.props['onClick'] == null;

    final isHaptic = eval<bool>(data.props['haptic'], context: context) ?? true;

    final disabledTextColor = disabledStyleJson['disabledTextColor'] as String?;
    final disabledIconColor = disabledStyleJson['disabledIconColor'] as String?;
    final content = _buildContent(context,
        overrideColor: isDisabled,
        disabledTextColor: disabledTextColor,
        disabledIconColor: disabledIconColor);

    final onPressedAction = isDisabled
        ? null
        : () {
            final onClick = ActionFlow.fromJson(data.props['onClick']);
            ActionHandler.instance
                .execute(context: context, actionFlow: onClick);
          };

    return ButtonBounceAnimation(
      onPressed: onPressedAction,
      enableHaptics: isHaptic,
      enableBounceAnimation: true,
      child: TextButton(
        onPressed: isDisabled ? null : () {},
        style: style,
        child: content,
      ),
    );
  }

  Widget _buildContent(BuildContext context,
      {bool overrideColor = false,
      String? disabledTextColor,
      String? disabledIconColor}) {
    Widget text;
    Widget? leadingIcon;
    Widget? trailingIcon;

    if (overrideColor) {
      data.props['text']?['textStyle']?['textColor'] = disabledTextColor;
    }

    final textBuilder = DUITextBuilder.fromProps(
        props: data.props['text'] as Map<String, dynamic>?);

    text = textBuilder.build(context);

    final leadingIconProps = data.props['leadingIcon'] as Map<String, dynamic>?;
    if (overrideColor) {
      leadingIconProps?['iconColor'] = disabledIconColor;
    }

    leadingIcon =
        DUIIconBuilder.fromProps(props: leadingIconProps)?.build(context);

    final trailingIconProps =
        data.props['trailingIcon'] as Map<String, dynamic>?;
    if (overrideColor) {
      trailingIconProps?['iconColor'] = disabledIconColor;
    }
    trailingIcon =
        DUIIconBuilder.fromProps(props: trailingIconProps)?.build(context);

    if (leadingIcon == null && trailingIcon == null) {
      return text;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) leadingIcon,
        Flexible(child: text),
        if (trailingIcon != null) trailingIcon,
      ],
    );
  }
}
