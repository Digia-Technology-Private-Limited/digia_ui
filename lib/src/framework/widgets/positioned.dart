import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/types.dart';

class VWPositioned extends VirtualStatelessWidget {
  VWPositioned({
    required super.props,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(
          commonProps: null,
          repeatData: null,
        );

  VWPositioned.fromValues({
    required VirtualWidget child,
    required VirtualWidget? parent,
    required JsonLike position,
  }) : this(
          props: Props({
            'position': position,
          }),
          parent: parent,
          childGroups: {
            'child': [child]
          },
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    return Positioned(
      top: props.getDouble('position.top'),
      bottom: props.getDouble('position.bottom'),
      left: props.getDouble('position.left'),
      right: props.getDouble('position.right'),
      child: child!.toWidget(payload),
    );
  }
}
