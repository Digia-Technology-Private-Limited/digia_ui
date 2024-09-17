import 'package:flutter/widgets.dart';

import '../../components/utils/DUIInsets/dui_insets.dart';
import '../core/virtual_stateless_widget.dart';
import '../core/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

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
    required DUIInsets position,
  }) : this(
          props: Props({
            'position': position,
            'hasPosition': true,
          }),
          parent: parent,
          childGroups: {
            'child': [child]
          },
        );

  @override
  Widget render(RenderPayload payload) {
    final position = DUIInsets.fromJson(props.get('position'));
    final childWidget = child!.toWidget(payload);
    return Positioned(
      top: double.tryParse(position.top),
      bottom: double.tryParse(position.bottom),
      left: double.tryParse(position.left),
      right: double.tryParse(position.right),
      child: childWidget,
    );
  }
}
