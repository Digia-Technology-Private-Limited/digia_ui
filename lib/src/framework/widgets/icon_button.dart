import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../core/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import 'icon.dart';

class VWIconButton extends VirtualLeafStatelessWidget {
  VWIconButton({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final icon = VWIcon(
      props: props['icon'] as Map<String, dynamic>,
      commonProps: commonProps,
      parent: this,
    ).render(payload);

    final defaultStyleJson =
        props['defaultStyle'] as Map<String, dynamic>? ?? {};
    final disabledStyleJson =
        props['disabledStyle'] as Map<String, dynamic>? ?? {};

    ButtonStyle style = ButtonStyle(
      padding: WidgetStateProperty.all(DUIDecoder.toEdgeInsets(
        defaultStyleJson['padding'],
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
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
    final height = DUIDecoder.getHeight(payload.buildContext, props['height']);
    final width = DUIDecoder.getWidth(payload.buildContext, props['width']);

    return SizedBox(
      height: height,
      width: width,
      child: IconButton(
        onPressed: isDisabled
            ? null
            : () {
                final onClick = ActionFlow.fromJson(props['onClick']);
                ActionHandler.instance.execute(
                  context: payload.buildContext,
                  actionFlow: onClick,
                );
              },
        icon: icon,
        style: style,
      ),
    );
  }
}
