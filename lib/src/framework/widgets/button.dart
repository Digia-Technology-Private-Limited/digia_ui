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
    final defaultStyleJson = props.toProps('defaultStyle') ?? Props.empty();
    final disabledStyleJson = props.toProps('disabledStyle') ?? Props.empty();

    //sizing constraints
    final width =
        defaultStyleJson.getString('width')?.toWidth(payload.buildContext);
    final height =
        defaultStyleJson.getString('height')?.toHeight(payload.buildContext);

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.all(
          To.buttonShape(props.get('shape'), payload.getColor)),
      padding: WidgetStateProperty.all(To.edgeInsets(
        defaultStyleJson.get('padding'),
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
      elevation: WidgetStateProperty.all(
        defaultStyleJson.getDouble('elevation') ?? 0.0,
      ),
      shadowColor: WidgetStateProperty.all(
          defaultStyleJson.getString('shadowColor').maybe(payload.getColor)),
      alignment: To.alignment(defaultStyleJson.get('alignment')),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledStyleJson
              .getString('backgroundColor')
              .maybe(payload.evalColor);
        }
        return defaultStyleJson
            .getString('backgroundColor')
            .maybe(payload.evalColor);
      }),
      fixedSize: width != null || height != null
          ? WidgetStateProperty.all(
              Size(width ?? double.infinity, height ?? double.infinity))
          : null,
    );

    final isDisabled = payload.eval<bool>(props.get('isDisabled')) ??
        props.get('onClick') == null;

    final disabledTextColor = disabledStyleJson.getString('disabledTextColor');
    final disabledIconColor = disabledStyleJson.getString('disabledIconColor');
    final content = _buildContent(
      payload,
      overrideColor: isDisabled,
      disabledTextColor: disabledTextColor,
      disabledIconColor: disabledIconColor,
    );

    return ElevatedButton(
      onPressed: isDisabled
          ? null
          : () {
              final onClick = ActionFlow.fromJson(props.get('onClick'));
              payload.executeAction(onClick);
            },
      style: style,
      child: content,
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
      parent: this,
    ).toWidget(payload);

    final leadingIconProps =
        (localProps['leadingIcon'] as Map<String, Object?>?)
            .maybe(IconProps.fromJson)
            ?.copyWith(
              color: ExprOr.fromJson<String>(overrideColor
                  ? disabledIconColor
                  : props.get('leadingIcon.iconColor')),
            );

    if (leadingIconProps != null) {
      leadingIcon = VWIcon(
        props: leadingIconProps,
        commonProps: null,
        parent: this,
      ).toWidget(payload);
    }

    final trailingIconProps =
        (localProps['trailingIcon'] as Map<String, Object?>?)
            .maybe(IconProps.fromJson)
            ?.copyWith(
              color: ExprOr.fromJson<String>(overrideColor
                  ? disabledIconColor
                  : props.get('trailingIcon.iconColor')),
            );

    if (trailingIconProps != null) {
      trailingIcon = VWIcon(
        props: trailingIconProps,
        commonProps: null,
        parent: this,
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
