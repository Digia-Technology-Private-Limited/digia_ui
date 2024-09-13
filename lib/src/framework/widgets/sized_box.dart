import 'package:flutter/widgets.dart';

import '../../core/flutter_widgets.dart';
import '../core/virtual_leaf_stateless_widget.dart';
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
    return FW.sizedBox(props);
  }
}
