import 'package:flutter/widgets.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/opacity_props.dart';

class VWOpacity extends VirtualStatelessWidget<OpacityProps> {
  VWOpacity({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final opacity = payload.evalExpr<double>(props.opacity) ?? 1.0;
    final alwaysIncludeSemantics =
        payload.evalExpr<bool>(props.alwaysIncludeSemantics) ?? false;

    return Opacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child?.toWidget(payload) ?? empty(),
    );
  }
}
