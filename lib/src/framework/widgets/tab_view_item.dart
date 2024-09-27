import 'package:flutter/material.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWTabViewItem extends VirtualStatelessWidget<Props> {
  VWTabViewItem({
    required super.props,
    super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) empty();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children!.toWidgetArray(payload),
    );
  }
}
