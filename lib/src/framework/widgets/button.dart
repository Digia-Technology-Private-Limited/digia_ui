import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'icon.dart';
import 'text.dart';

class VWButton extends VirtualLeafStatelessWidget {
  VWButton({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final defaultStyleJson = props.getMap('defaultStyle') ?? {};
    final disabledStyleJson = props.getMap('disabledStyle') ?? {};

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.all(toButtonShape(props.get('shape'))),
      padding: WidgetStateProperty.all(DUIDecoder.toEdgeInsets(
        defaultStyleJson['padding'],
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
      elevation: WidgetStateProperty.all(
        NumDecoder.toDouble(defaultStyleJson['elevation']),
      ),
      shadowColor:
          WidgetStateProperty.all(makeColor(defaultStyleJson['shadowColor'])),
      alignment: DUIDecoder.toAlignment(defaultStyleJson['alignment']),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return makeColor(disabledStyleJson['backgroundColor']);
        }
        return makeColor(defaultStyleJson['backgroundColor']);
      }),
    );

    final isDisabled = payload.eval<bool>(props.get('isDisabled')) ??
        props.get('onClick') == null;

    final disabledTextColor = disabledStyleJson['disabledTextColor'] as String?;
    final disabledIconColor = disabledStyleJson['disabledIconColor'] as String?;
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
              ActionHandler.instance.execute(
                context: payload.buildContext,
                actionFlow: onClick,
              );
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

    final localProps = Map<String, dynamic>.from(props.value);

    if (overrideColor) {
      localProps['text']?['textStyle']?['textColor'] = disabledTextColor;
    } else {
      localProps['text']?['textStyle']?['textColor'] =
          props.get('text.textStyle.textColor');
    }

    text = VWText(
      props: Props(localProps['text'] as Map<String, Object?>? ?? {}),
      commonProps: commonProps,
      parent: this,
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
        commonProps: null,
        parent: null,
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
