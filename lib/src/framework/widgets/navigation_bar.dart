import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/bottom_navigation_bar/bottom_navigation_bar.dart'
    as internal;
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/navigation_bar_props.dart';
import 'container.dart';
import 'nav_bar_item_default.dart';

class VWNavigationBar extends VirtualStatelessWidget<NavigationBarProps> {
  void Function(int)? onDestinationSelected;
  final int selectedIndex;

  VWNavigationBar({
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

  @override
  Widget render(RenderPayload payload) {
    return internal.BottomNavigationBar(
      borderRadius: To.borderRadius(props.borderRadius),
      shadow: toShadowList(payload, props.shadow),
      elevation: payload.evalExpr(props.elevation),
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
      labelBehavior: payload.evalExpr(props.showLabels) ?? true
          ? NavigationDestinationLabelBehavior.alwaysShow
          : NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: selectedIndex,
      destinations: children
              ?.whereType<VWNavigationBarItemDefault>()
              .map((e) => e.toWidget(payload))
              .toList() ??
          [],
      onDestinationSelected: (value) {
        handleDestinationSelected(value, payload);
      },
    );
  }
}
