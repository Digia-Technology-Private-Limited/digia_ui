import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../core/virtual_leaf_stateless_widget.dart';
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
    final defaultStyleJson =
        props['defaultStyle'] as Map<String, dynamic>? ?? {};
    final disabledStyleJson =
        props['disabledStyle'] as Map<String, dynamic>? ?? {};

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.all(toButtonShape(props['shape'])),
      padding: WidgetStateProperty.all(DUIDecoder.toEdgeInsets(
        defaultStyleJson['padding'],
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
      elevation: WidgetStateProperty.all(
        NumDecoder.toDouble(defaultStyleJson['elevation']),
      ),
      shadowColor: WidgetStateProperty.all(defaultStyleJson['shadowColor']),
      alignment: DUIDecoder.toAlignment(defaultStyleJson['alignment']),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return makeColor(disabledStyleJson['backgroundColor']);
        }
        return makeColor(defaultStyleJson['backgroundColor']);
      }),
    );

    final isDisabled =
        payload.eval<bool>(props['isDisabled']) ?? props['onClick'] == null;

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
              final onClick = ActionFlow.fromJson(props['onClick']);
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

    final localProps = Map<String, dynamic>.from(props);

    if (overrideColor) {
      localProps['text']?['textStyle']?['textColor'] = disabledTextColor;
    } else {
      localProps['text']?['textStyle']?['textColor'] =
          props.valueFor(keyPath: 'text.textStyle.textColor');
    }

    text = VWText(
      props: localProps['text'] as Map<String, dynamic>,
      commonProps: commonProps,
      parent: this,
    ).render(payload);

    final leadingIconProps = localProps['leadingIcon'] as Map<String, dynamic>?;
    if (overrideColor) {
      leadingIconProps?['iconColor'] = disabledIconColor;
    } else {
      leadingIconProps?['iconColor'] =
          props.valueFor(keyPath: 'leadingIcon.iconColor');
    }

    if (leadingIconProps != null) {
      leadingIcon = VWIcon(
        props: leadingIconProps,
        commonProps: commonProps,
        parent: this,
      ).render(payload);
    }

    final trailingIconProps =
        localProps['trailingIcon'] as Map<String, dynamic>?;
    if (overrideColor) {
      trailingIconProps?['iconColor'] = disabledIconColor;
    } else {
      trailingIconProps?['iconColor'] =
          props.valueFor(keyPath: 'trailingIcon.iconColor');
    }

    if (trailingIconProps != null) {
      trailingIcon = VWIcon(
        props: trailingIconProps,
        commonProps: commonProps,
        parent: this,
      ).render(payload);
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
