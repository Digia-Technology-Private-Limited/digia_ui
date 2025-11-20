import 'dart:convert';

import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../models/types.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import '../widget_props/icon_props.dart';
import '../widget_props/text_props.dart';
import 'icon.dart';
import 'text.dart';

enum ButtonState {
  defaultState,
  disabledState,
}

class VWButton extends VirtualLeafStatelessWidget<Props> {
  VWButton({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final buttonState = _getButtonState(props.getString('buttonState') ?? '');
    final defaultStyleJson = props.toProps('defaultStyle') ?? Props.empty();
    final disabledStyleJson = props.toProps('disabledStyle') ?? Props.empty();

    // Determine colors based on state
    final backgroundColor = buttonState == ButtonState.defaultState
        ? payload.evalColor(defaultStyleJson.getString('backgroundColor'))
        : (payload.evalColor(disabledStyleJson.getString('backgroundColor')) ??
            const Color(0xFFE0E0E0)); // AppColorsV2.contentDisabled fallback

    final textColor = buttonState == ButtonState.defaultState
        ? props.getString('text.textStyle.textColor')
        : disabledStyleJson.getString('disabledTextColor');

    final leadingIconColor = buttonState == ButtonState.defaultState
        ? props.getString('leadingIcon.iconColor')
        : disabledStyleJson.getString('disabledIconColor');

    final trailingIconColor = buttonState == ButtonState.defaultState
        ? props.getString('trailingIcon.iconColor')
        : disabledStyleJson.getString('disabledIconColor');

    // Sizing constraints
    final width =
        defaultStyleJson.getString('width')?.toWidth(payload.buildContext);
    final height =
        defaultStyleJson.getString('height')?.toHeight(payload.buildContext);

    // Match CWButton styling exactly
    final style = ElevatedButton.styleFrom(
      padding: To.edgeInsets(defaultStyleJson.get('padding')),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.standard,
      minimumSize: Size.zero,
      backgroundColor: backgroundColor,
      elevation: defaultStyleJson.getDouble('elevation') ?? 0.0,
      shadowColor: payload.evalColor(defaultStyleJson.getString('shadowColor')),
      alignment: To.alignment(defaultStyleJson.get('alignment')),
      fixedSize: width != null || height != null
          ? Size(width ?? double.infinity, height ?? double.infinity)
          : null,
      shape: To.buttonShape(
        props.get('shape'),
        payload.getColor,
      ),
    );

    final content = _buildContent(
      payload,
      textColor: textColor,
      leadingIconColor: leadingIconColor,
      trailingIconColor: trailingIconColor,
    );

    // Logic for interactivity
    final isDisabled = payload.eval<bool>(props.get('isDisabled')) ??
        props.get('onClick') == null ||
            buttonState == ButtonState.disabledState;

    return ElevatedButton(
      onPressed: isDisabled
          ? null
          : () {
              final onClick = ActionFlow.fromJson(props.get('onClick'));
              payload.executeAction(
                onClick,
                triggerType: 'onPressed',
              );
            },
      style: style,
      child: content,
    );
  }

  Widget _buildContent(
    RenderPayload payload, {
    String? textColor,
    String? leadingIconColor,
    String? trailingIconColor,
  }) {
    Widget text;
    Widget? leadingIcon;
    Widget? trailingIcon;

    // Clone props to modify locally without affecting original state
    final JsonLike localProps =
        jsonDecode(jsonEncode(props.value)) as JsonLike? ?? {};

    // Apply text color override
    if (textColor != null) {
      localProps.setValueFor('text.textStyle.textColor', textColor);
    }

    text = VWText(
      props: as$<JsonLike>(localProps['text']).maybe(TextProps.fromJson) ??
          TextProps(),
      commonProps: null,
      parent: this,
    ).toWidget(payload);

    // Leading Icon
    final leadingIconData = props.get('leadingIcon.iconData');
    if (leadingIconData != null) {
      final leadingIconProps =
          (localProps['leadingIcon'] as Map<String, Object?>?)
              .maybe(IconProps.fromJson)
              ?.copyWith(
                color: ExprOr.fromJson<String>(leadingIconColor),
              );

      if (leadingIconProps != null) {
        leadingIcon = VWIcon(
          props: leadingIconProps,
          commonProps: null,
          parent: this,
        ).toWidget(payload);
      }
    }

    // Trailing Icon
    final trailingIconData = props.get('trailingIcon.iconData');
    if (trailingIconData != null) {
      final trailingIconProps =
          (localProps['trailingIcon'] as Map<String, Object?>?)
              .maybe(IconProps.fromJson)
              ?.copyWith(
                color: ExprOr.fromJson<String>(trailingIconColor),
              );

      if (trailingIconProps != null) {
        trailingIcon = VWIcon(
          props: trailingIconProps,
          commonProps: null,
          parent: this,
        ).toWidget(payload);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        leadingIcon ?? const SizedBox.shrink(),
        Flexible(child: text),
        trailingIcon ?? const SizedBox.shrink(),
      ],
    );
  }

  ButtonState _getButtonState(String buttonState) {
    switch (buttonState) {
      case 'default':
        return ButtonState.defaultState;
      case 'disabled':
        return ButtonState.disabledState;
      default:
        return ButtonState.defaultState;
    }
  }
}
