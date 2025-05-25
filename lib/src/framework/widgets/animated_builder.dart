import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWAnimatedBuilder extends VirtualStatelessWidget<Props> {
  VWAnimatedBuilder({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final ChangeNotifier? notifier =
        payload.eval<ChangeNotifier>(props.get('notifier'));

    if (notifier == null) return empty();

    return AnimatedBuilder(
      animation: notifier,
      builder: (context, _) => child!.toWidget(payload),
    );
  }
}
