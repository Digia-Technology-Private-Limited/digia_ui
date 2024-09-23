import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../components/dui_button_bounce_animation.dart';
import '../../core/action/action_handler.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'icon.dart';
import 'text.dart';

class VWAnimatedButton extends VirtualLeafStatelessWidget {
  VWAnimatedButton({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final defaultStyleJson = props.toProps('defaultStyle') ?? Props.empty();
    final disabledStyleJson = props.toProps('disabledStyle') ?? Props.empty();

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.all(toButtonShape(props.get('shape'))),
      padding: WidgetStateProperty.all(DUIDecoder.toEdgeInsets(
        defaultStyleJson.getMap('padding'),
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
      elevation: WidgetStateProperty.all(
        defaultStyleJson.getDouble('elevation'),
      ),
      alignment:
          DUIDecoder.toAlignment(defaultStyleJson.getString('alignment')),
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return makeColor(disabledStyleJson.get('backgroundColor'));
        }
        return makeColor(defaultStyleJson.get('backgroundColor'));
      }),
    );

    final isDisabled = payload.eval<bool>(props.get('isDisabled')) ??
        props.get('onClick') == null;
    final isHaptic = payload.eval<bool>(props.get('haptic')) ?? true;

    final disabledTextColor = disabledStyleJson.getString('disabledTextColor');
    final disabledIconColor = disabledStyleJson.getString('disabledIconColor');
    final content = _buildContent(
      payload,
      overrideColor: isDisabled,
      disabledTextColor: disabledTextColor,
      disabledIconColor: disabledIconColor,
    );

    final onPressedAction = isDisabled
        ? null
        : () {
            final onClick = ActionFlow.fromJson(props.get('onClick'));
            payload.executeAction(onClick);
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

  Widget _buildContent(
    RenderPayload payload, {
    bool overrideColor = false,
    String? disabledTextColor,
    String? disabledIconColor,
  }) {
    Widget text;
    Widget? leadingIcon;
    Widget? trailingIcon;

    final localProps = Map<String, dynamic>.from(props.value);

    if (overrideColor) {
      localProps['text']?['textStyle']?['textColor'] = disabledTextColor;
    } else {
      localProps['text']?['textStyle']?['textColor'] =
          props.get('text.textStyle.textColor');
    }

    text = VWText(
      props: Props(localProps['text'] as Map<String, Object?>? ?? {}),
      commonProps: null,
      parent: null,
    ).toWidget(payload);

    final leadingIconProps = localProps['leadingIcon'] as Map<String, Object?>?;
    if (overrideColor) {
      leadingIconProps?['iconColor'] = disabledIconColor;
    } else {
      leadingIconProps?['iconColor'] = props.get('leadingIcon.iconColor');
    }

    if (leadingIconProps != null) {
      leadingIcon = VWIcon(
        props: Props(leadingIconProps),
        commonProps: commonProps,
        parent: this,
      ).toWidget(payload);
    }

    final trailingIconProps =
        localProps['trailingIcon'] as Map<String, Object?>?;
    if (overrideColor) {
      trailingIconProps?['iconColor'] = disabledIconColor;
    } else {
      trailingIconProps?['iconColor'] = props.get('trailingIcon.iconColor');
    }

    if (trailingIconProps != null) {
      trailingIcon = VWIcon(
        props: Props(trailingIconProps),
        commonProps: null,
        parent: null,
      ).toWidget(payload);
    }

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
