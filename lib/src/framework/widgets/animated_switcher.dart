import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/animated_switcher_props.dart';

class VWAnimatedSwitcher extends VirtualStatelessWidget<AnimatedSwitcherProps> {
  VWAnimatedSwitcher({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final firstChild = childOf('firstChild');
    if (firstChild == null) return empty();

    final secondChild = childOf('secondChild');
    final animationDuration =
        payload.evalExpr<int>(props.animationDuration) ?? 100;
    final showFirstChild = payload.evalExpr<bool>(props.showFirstChild);

    return AnimatedSwitcher(
        duration: Duration(milliseconds: animationDuration),
        switchInCurve: props.switchInCurve ?? Curves.linear,
        switchOutCurve: props.switchOutCurve ?? Curves.linear,
        child: KeyedSubtree(
            key: ValueKey(showFirstChild),
            child: showFirstChild ?? true
                ? firstChild.toWidget(payload)
                : Container(
                    key: ValueKey<int>(2),
                    child: secondChild?.toWidget(payload))));
  }
}
