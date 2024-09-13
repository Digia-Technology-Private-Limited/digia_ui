import 'package:flutter/widgets.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWOpacity extends VirtualStatelessWidget {
  VWOpacity({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    final opacity = payload.eval<double>(props.get('opacity')) ?? 1.0;
    final alwaysIncludeSemantics =
        payload.eval<bool>(props.get('alwaysIncludeSemantics')) ?? false;

    return Opacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child?.toWidget(payload) ?? empty(),
    );
  }
}
