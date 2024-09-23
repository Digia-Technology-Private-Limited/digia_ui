import 'package:flutter/widgets.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';

class VWSizedBox extends VirtualLeafStatelessWidget {
  VWSizedBox({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final width = props.getDouble('width');
    final height = props.getDouble('height');
    return SizedBox(
      width: width,
      height: height,
    );
  }
}
