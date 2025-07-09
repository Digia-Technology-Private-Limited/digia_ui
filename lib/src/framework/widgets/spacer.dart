import 'package:flutter/widgets.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWSpacer extends VirtualLeafStatelessWidget<Props> {
  VWSpacer({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    return SizedBox.shrink();
  }
}
