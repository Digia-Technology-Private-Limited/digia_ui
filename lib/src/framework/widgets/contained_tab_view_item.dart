import 'package:flutter/material.dart';
import '../base/extensions.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWContainedTabViewItem extends VirtualStatelessWidget<Props> {
  VWContainedTabViewItem({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children!.toWidgetArray(payload),
    );
  }
}
