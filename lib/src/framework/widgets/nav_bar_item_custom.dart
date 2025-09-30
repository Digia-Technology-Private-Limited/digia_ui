import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/bottom_navigation_bar/inherited_navigation_bar_controller.dart';
import '../internal_widgets/inherited_scaffold_controller.dart';
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

    // Get the current item index from the navigation bar controller
    final navBarController =
        InheritedNavigationBarController.maybeOf(payload.buildContext);
    final itemIndex = navBarController?.itemIndex;

    // Get the selected index from the scaffold controller
    final scaffoldController =
        InheritedScaffoldController.maybeOf(payload.buildContext);
    final selectedIndex = scaffoldController?.currentIndex;

    // Determine if this item is selected
    final isSelected = itemIndex != null &&
        selectedIndex != null &&
        itemIndex == selectedIndex;

    // Get the appropriate child based on selection state
    final selectedChild = childGroups?['selected']?.firstOrNull;
    final unselectedChild = childGroups?['unselected']?.firstOrNull;
    final activeChild = isSelected ? selectedChild : unselectedChild;

    return NavigationDestination(
      icon: activeChild?.toWidget(payload) ?? empty(),
      label: '',
    );
  }
}
