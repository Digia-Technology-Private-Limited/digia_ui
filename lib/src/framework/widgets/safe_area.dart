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
    final child = childOf('child');

    final bottom = payload.eval<bool>(props['bottom']) ?? true;
    final top = payload.eval<bool>(props['top']) ?? true;

    return SafeArea(
      bottom: bottom,
      top: top,
      child: child?.render(payload) ?? empty(),
    );
  }
}
