import 'package:flutter/widgets.dart';

import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWSafeArea extends VirtualStatelessWidget {
  VWSafeArea({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    final bottom = payload.eval<bool>(props.get('bottom')) ?? true;
    final top = payload.eval<bool>(props.get('top')) ?? true;

    return SafeArea(
      bottom: bottom,
      top: top,
      child: child?.toWidget(payload) ?? empty(),
    );
  }
}
