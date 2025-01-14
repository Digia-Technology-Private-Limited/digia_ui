import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/internal_overlay.dart';
import '../models/props.dart';

class VWOverlay extends VirtualStatelessWidget<Props> {
  VWOverlay({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final childWidget = childOf('childWidget');
    final popupWidget = childOf('popupWidget');

    if (childWidget == null) return empty();

    final childAlignment =
        To.alignment(props.getString('childAlignment')) ?? Alignment.center;
    final popupAlignment =
        To.alignment(props.getString('popupAlignment')) ?? Alignment.center;

    return InternalOverlay(
      popupBuilder: (ctx, controller) =>
          popupWidget?.toWidget(payload) ?? const SizedBox.shrink(),
      childAlignment: childAlignment,
      popupAlignment: popupAlignment,
      child: childWidget.toWidget(payload),
    );
  }
}
