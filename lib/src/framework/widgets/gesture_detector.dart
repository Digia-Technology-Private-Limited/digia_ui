import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWGestureDetector extends VirtualStatelessWidget<Props> {
  VWGestureDetector({
    required super.props,
    required super.parent,
    super.refName,
    required super.childGroups,
  }) : super(
          commonProps: null,
          repeatData: null,
        );

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final childWidget = child!.toWidget(payload);

    final actionFlow = ActionFlow.fromJson(props.get('actionFlow'));
    if (actionFlow.actions.isEmpty) return childWidget;

    onTap() {
      payload.executeAction(actionFlow);
    }

    if (actionFlow.inkwell) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap,
          borderRadius: To.borderRadius(props.get('borderRadius')),
          child: childWidget,
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: childWidget,
      );
    }
  }
}
