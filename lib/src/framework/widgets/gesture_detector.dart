import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWGestureDetector extends VirtualStatelessWidget {
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
          borderRadius: DUIDecoder.toBorderRadius(props.get('borderRadius')),
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
