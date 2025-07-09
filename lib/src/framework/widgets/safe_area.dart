import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../widget_props/safe_area_props.dart';

class VWSafeArea extends VirtualStatelessWidget<SafeAreaProps> {
  VWSafeArea({
    SafeAreaProps? props,
    super.refName,
    required super.childGroups,
    super.parentProps,
  }) : super(
          props: props ?? const SafeAreaProps(),
          commonProps: null,
          parent: null,
        );

  VWSafeArea.withChild(
    VirtualWidget child,
  ) : this(
          childGroups: {
            'child': [child],
          },
        );

  @override
  Widget render(RenderPayload payload) {
    final left = payload.evalExpr(props.left) ?? true;
    final top = payload.evalExpr(props.top) ?? true;
    final right = payload.evalExpr(props.right) ?? true;
    final bottom = payload.evalExpr(props.bottom) ?? true;

    return SafeArea(
      bottom: bottom,
      top: top,
      left: left,
      right: right,
      child: child?.toWidget(payload) ?? empty(),
    );
  }
}
