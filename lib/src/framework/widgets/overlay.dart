import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/internal_overlay.dart';
import '../models/props.dart';

class VWOverlay extends VirtualStatelessWidget<Props> {
  VWOverlay({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

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
      offset: Offset(props.getDouble('offset.xAxis') ?? 0,
          props.getDouble('offset.yAxis') ?? 0),
      dismissOnTapOutside: props.getBool('dismissOnTapOutside') ?? true,
      dismissOnTapInside: props.getBool('dismissOnTapInside') ?? false,
      popupAlignment: popupAlignment,
      child: childWidget.toWidget(payload),
    );
  }
}
