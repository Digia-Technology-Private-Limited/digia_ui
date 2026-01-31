import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import '../widget_props/conditional_item_props.dart';

class VWConditionItem extends VirtualStatelessWidget<ConditionalItemProps> {
  VWConditionItem({
    required super.props,
    super.refName,
    required super.childGroups,
  }) : super(
          parent: null,
          commonProps: null,
        );

  bool evaluate(ScopeContext scopeContext) {
    return props.condition?.evaluate(scopeContext) ?? false;
  }

  @override
  Widget render(RenderPayload payload) {
    return child?.toWidget(payload) ?? empty();
  }
}
