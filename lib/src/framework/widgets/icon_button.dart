import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/object_util.dart';
import 'icon.dart';

class VWIconButton extends VirtualLeafStatelessWidget<Props> {
  VWIconButton({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final icon = VWIcon(
      props: props.toProps('icon') ?? Props.empty(),
      commonProps: commonProps,
      parent: this,
    ).toWidget(payload);

    final defaultStyleJson = props.getMap('defaultStyle') ?? {};
    final disabledStyleJson = props.getMap('disabledStyle') ?? {};

    ButtonStyle style = ButtonStyle(
      padding: WidgetStateProperty.all(To.edgeInsets(
        defaultStyleJson['padding'],
        or: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      )),
      alignment: To.alignment(defaultStyleJson['alignment']),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return disabledStyleJson['backgroundColor']
              ?.to<String>()
              .maybe(payload.getColor);
        }
        return defaultStyleJson['backgroundColor']
            ?.to<String>()
            .maybe(payload.getColor);
      }),
    );

    final isDisabled = payload.eval<bool>(props.get('isDisabled')) ??
        props.get('onClick') == null;
    final height = props.getString('height')?.toHeight(payload.buildContext);
    final width = props.getString('width')?.toWidth(payload.buildContext);

    return SizedBox(
      height: height,
      width: width,
      child: IconButton(
        onPressed: isDisabled
            ? null
            : () {
                final onClick = ActionFlow.fromJson(props.get('onClick'));
                payload.executeAction(onClick);
              },
        icon: icon,
        style: style,
      ),
    );
  }
}
