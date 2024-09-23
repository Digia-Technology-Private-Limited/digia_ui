import 'package:flutter/widgets.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWSpacer extends VirtualLeafStatelessWidget {
  VWSpacer({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final flex = props.getInt('flex') ?? 1;
    return Spacer(flex: flex);
  }
}
