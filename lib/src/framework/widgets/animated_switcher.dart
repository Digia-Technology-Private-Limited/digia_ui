import 'package:flutter/widgets.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/internal_animated_switcher.dart';
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

    return InternalAnimatedSwitcher(
      animationDuration: animationDuration,
      showFirstChild: showFirstChild,
      firstChild: firstChild.toWidget(payload),
      secondChild: secondChild?.toWidget(payload),
      switchInCurve: props.switchInCurve ?? Curves.linear,
      switchOutCurve: props.switchOutCurve ?? Curves.linear,
    );
  }
}
