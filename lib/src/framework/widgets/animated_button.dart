import 'dart:convert';

import 'package:flutter/material.dart';

import '../../components/dui_button_bounce_animation.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import '../widget_props/text_props.dart';
import 'icon.dart';
import 'text.dart';

class VWAnimatedButton extends VirtualLeafStatelessWidget<Props> {
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
      shape: WidgetStateProperty.all(
          To.buttonShape(props.get('shape'), payload.getColor)),
      padding: WidgetStateProperty.all(To.edgeInsets(
        defaultStyleJson.get('padding'),
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
      elevation: WidgetStateProperty.all(
        defaultStyleJson.getDouble('elevation'),
      ),
      alignment: To.alignment(defaultStyleJson.getString('alignment')),
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return payload.evalColor(disabledStyleJson.get('backgroundColor'));
        }
        return payload.evalColor(defaultStyleJson.get('backgroundColor'));
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

    final JsonLike localProps =
        jsonDecode(jsonEncode(props.value)) as JsonLike? ?? {};

    if (overrideColor) {
      localProps.setValueFor('text.textStyle.textColor', disabledTextColor);
    } else {
      localProps.setValueFor(
          'text.textStyle.textColor', props.get('text.textStyle.textColor'));
    }

    text = VWText(
      props: as$<JsonLike>(localProps['text']).maybe(TextProps.fromJson) ??
          TextProps(),
      commonProps: null,
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
