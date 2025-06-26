import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/virtual_stateless_widget.dart';
import '../widget_props/nav_bar_item_custom.dart';

class VWNavigationBarItemCustom
    extends VirtualStatelessWidget<NavigationBarItemCustomProps> {
  VWNavigationBarItemCustom({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final showIf = props.showIf?.evaluate(payload.scopeContext);
    if (showIf == false) return empty();

    return NavigationDestination(
      icon: child?.toWidget(payload) ?? empty(),
      label: '',
    );
  }
}
