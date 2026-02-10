import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'conditional_item.dart';

class VWConditionalBuilder extends VirtualStatelessWidget<Props> {
  VWConditionalBuilder({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  VirtualWidget? getEvalChild(RenderPayload payload) {
    final conditonalItemChildren = children?.whereType<VWConditionItem>();

    if (conditonalItemChildren == null || conditonalItemChildren.isEmpty) {
      return null;
    }

    return (conditonalItemChildren
        .firstWhereOrNull((e) => e.evaluate(payload.scopeContext)))?.child;
  }

  @override
  Widget render(RenderPayload payload) {
    return getEvalChild(payload)?.toWidget(payload) ?? empty();
  }
}
