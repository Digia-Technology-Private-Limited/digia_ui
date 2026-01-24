import 'package:flutter/widgets.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../render_payload.dart';
import '../widget_props/positioned_props.dart';
class VWPositioned extends VirtualStatelessWidget<PositionedProps> {
  VWPositioned({
    required super.props,
    required super.parent,
    super.refName,
    required VirtualWidget child,
  }) : super(
          commonProps: null,
          childGroups: {
            'child': [child]
          },
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    return Positioned(
      top: props.top,
      bottom: props.bottom,
      left: props.left,
      right: props.right,
      child: child!.toWidget(payload),
    );
  }
}