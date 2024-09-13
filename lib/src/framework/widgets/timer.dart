import 'package:flutter/widgets.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_timer.dart';
import '../render_payload.dart';

class VWTimer extends VirtualStatelessWidget {
  VWTimer({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    return InternalTimer(
      props: props,
      payload: payload,
      child: childOf('child'),
    );
  }
}
