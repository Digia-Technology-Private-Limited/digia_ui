import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/bottom_navigation_bar/bottom_navigation_bar.dart'
    as internal;
import '../internal_widgets/bottom_navigation_bar/inherited_navigation_bar_controller.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/navigation_bar_custom_props.dart';
import 'container.dart';
import 'nav_bar_item_custom.dart';

class VWNavigationBarCustom
    extends VirtualStatelessWidget<NavigationBarCustomProps> {
  void Function(int)? onDestinationSelected;
  final int selectedIndex;

  VWNavigationBarCustom({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.childGroups,
    super.refName,
    this.onDestinationSelected,
    this.selectedIndex = 0,
  });

  void handleDestinationSelected(int index, RenderPayload payload) {
    onDestinationSelected?.call(index);
  }

  List<Widget> _buildDestinations(RenderPayload payload) {
    final navItems =
        children?.whereType<VWNavigationBarItemCustom>().toList() ?? [];
    final destinations = <Widget>[];

    for (int i = 0; i < navItems.length; i++) {
      destinations.add(
        InheritedNavigationBarController(
          itemIndex: i,
          child: Builder(builder: (navItemContext) {
            return navItems[i].toWidget(payload.copyWith(
              buildContext: navItemContext,
            ));
          }),
        ),
      );
    }

    return destinations;
  }

  @override
  Widget render(RenderPayload payload) {
    return internal.BottomNavigationBar(
      borderRadius: To.borderRadius(props.borderRadius),
      shadow: toShadowList(payload, props.shadow),
      backgroundColor: payload.evalColorExpr(props.backgroundColor),
      animationDuration: Duration(
          milliseconds: payload.evalExpr(props.animationDuration) ?? 0),
      height: payload.evalExpr(props.height),
      surfaceTintColor: payload.evalColorExpr(props.surfaceTintColor),
      overlayColor:
          WidgetStateProperty.all(payload.evalColorExpr(props.overlayColor)),
      indicatorColor: payload.evalColorExpr(props.indicatorColor),
      indicatorShape: To.buttonShape(
          payload.evalExpr(props.indicatorShape), payload.getColor),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: selectedIndex,
      destinations: _buildDestinations(payload),
      onDestinationSelected: (value) {
        handleDestinationSelected(value, payload);
      },
    );
  }
}
