import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import 'condtional_item.dart';

class VWConditionalBuilder extends VirtualStatelessWidget<Props> {
  VWConditionalBuilder({
    super.commonProps,
    super.refName,
    required super.childGroups,
  }) : super(
          props: Props.empty(),
          parent: null,
          repeatData: null,
        );

  @override
  Widget render(RenderPayload payload) {
    final conditonalItemChildren = children?.whereType<VWConditionItem>();

    if (conditonalItemChildren == null || conditonalItemChildren.isEmpty) {
      return empty();
    }

    return conditonalItemChildren
            .firstWhereOrNull((e) => e.evaluate(payload.scopeContext))
            ?.toWidget(payload) ??
        empty();
  }
}
