import 'package:flutter/widgets.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/spacer_props.dart';

class VWSpacer extends VirtualLeafStatelessWidget<SpacerProps> {
  VWSpacer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return Spacer(flex: props.flex);
  }
}
