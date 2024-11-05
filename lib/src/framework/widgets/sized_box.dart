import 'package:flutter/widgets.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/sized_box_props.dart';

class VWSizedBox extends VirtualLeafStatelessWidget<SizedBoxProps> {
  VWSizedBox({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return SizedBox(
      width: props.width,
      height: props.height,
    );
  }
}
