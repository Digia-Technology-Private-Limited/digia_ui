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

    final isDisabled = payload.eval<bool>(props.get('isDisabled')) ??
        props.get('onClick') == null;

    final backgroundColor = isDisabled
        ? (payload.evalColor(disabledStyleJson.getString('backgroundColor')) ??
            const Color(0xFFE0E0E0))
        : payload.evalColor(defaultStyleJson.getString('backgroundColor'));

    final textColor = isDisabled
        ? disabledStyleJson.getString('disabledTextColor')
        : props.getString('text.textStyle.textColor');

    final leadingIconColor = isDisabled
        ? disabledStyleJson.getString('disabledIconColor')
        : props.getString('leadingIcon.iconColor');

    final trailingIconColor = isDisabled
        ? disabledStyleJson.getString('disabledIconColor')
        : props.getString('trailingIcon.iconColor');

    final width =
        defaultStyleJson.getString('width')?.toWidth(payload.buildContext);
    final height =
        defaultStyleJson.getString('height')?.toHeight(payload.buildContext);

    final style = ButtonStyle(
      shape: WidgetStateProperty.all(
        To.buttonShape(
          props.get('shape'),
          payload.getColor,
        ),
      ),
      padding: WidgetStateProperty.all(
          To.edgeInsets(defaultStyleJson.get('padding'))),
      elevation: WidgetStateProperty.all(
        defaultStyleJson.getDouble('elevation') ?? 0.0,
      ),
      shadowColor: WidgetStateProperty.all(
        payload.evalColor(defaultStyleJson.getString('shadowColor')),
      ),
      alignment: To.alignment(defaultStyleJson.get('alignment')),
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      fixedSize: (width != null || height != null)
          ? WidgetStateProperty.all(
              Size(width ?? double.infinity, height ?? double.infinity),
            )
          : null,
      minimumSize: WidgetStateProperty.all(Size.zero),
    );

    final content = _buildContent(
      payload,
      textColor: textColor,
      leadingIconColor: leadingIconColor,
      trailingIconColor: trailingIconColor,
    );

    return ElevatedButton(
      onPressed: isDisabled
          ? null
          : () {
              final onClick = ActionFlow.fromJson(props.get('onClick'));
              payload.executeAction(onClick, triggerType: 'onPressed');
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
    final JsonLike localProps =
        jsonDecode(jsonEncode(props.value)) as JsonLike? ?? {};

    if (textColor != null) {
      localProps.setValueFor('text.textStyle.textColor', textColor);
    }

    final text = VWText(
      props: as$<JsonLike>(localProps['text']).maybe(TextProps.fromJson) ??
          TextProps(),
      commonProps: null,
      parent: this,
    ).toWidget(payload);

    Widget? leadingIcon;
    final leadingIconData = props.get('leadingIcon.iconData');
    if (leadingIconData != null) {
      final leadingIconProps =
          (localProps['leadingIcon'] as Map<String, Object?>?)
              .maybe(IconProps.fromJson)
              ?.copyWith(color: ExprOr.fromJson<String>(leadingIconColor));
      if (leadingIconProps != null) {
        leadingIcon = VWIcon(
          props: leadingIconProps,
          commonProps: null,
          parent: this,
        ).toWidget(payload);
      }
    }

    Widget? trailingIcon;
    final trailingIconData = props.get('trailingIcon.iconData');
    if (trailingIconData != null) {
      final trailingIconProps =
          (localProps['trailingIcon'] as Map<String, Object?>?)
              .maybe(IconProps.fromJson)
              ?.copyWith(color: ExprOr.fromJson<String>(trailingIconColor));
      if (trailingIconProps != null) {
        trailingIcon = VWIcon(
          props: trailingIconProps,
          commonProps: null,
          parent: this,
        ).toWidget(payload);
      }
    }

    if (leadingIcon == null && trailingIcon == null) {
      return text;
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
}
