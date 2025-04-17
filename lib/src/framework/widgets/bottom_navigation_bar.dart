import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/bottom_navigation_bar.dart' as internal;
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/bottom_navigation_bar_props.dart';
import '../widgets/container.dart';
import 'bottom_navigation_bar_item.dart';

class VWBottomNavigationBar
    extends VirtualStatelessWidget<BottomNavigationBarProps> {
  void Function(int)? onDestinationSelected;

  VWBottomNavigationBar({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
    this.onDestinationSelected,
  }) : super(repeatData: null);

  void handleDestinationSelected(int index, RenderPayload payload) {
    final selectedChild = children?.elementAt(index);
    if (selectedChild is VWBottomNavigationBarItem) {
      final onPageSelected = selectedChild.props.onPageSelected;
      payload.executeAction(onPageSelected);
    }
    onDestinationSelected?.call(index);
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
      labelBehavior: payload.evalExpr(props.showLabels) ?? true
          ? NavigationDestinationLabelBehavior.alwaysShow
          : NavigationDestinationLabelBehavior.alwaysHide,
      destinations: children
              ?.whereType<VWBottomNavigationBarItem>()
              .map((e) => e.toWidget(payload))
              .toList() ??
          [],
      onDestinationSelected: (value) {
        handleDestinationSelected(value, payload);
      },
    );
  }
}
