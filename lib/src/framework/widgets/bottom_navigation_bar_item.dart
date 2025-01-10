import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../widget_props/bottom_navigation_bar_item_props.dart';
import '../widget_props/icon_props.dart';
import 'icon.dart';

class VWBottomNavigationBarItem
    extends VirtualLeafStatelessWidget<BottomNavigationBarItemProps> {
  VWBottomNavigationBarItem({
    required super.props,
    super.refName,
  }) : super(
          parent: null,
          commonProps: null,
        );

  @override
  Widget render(RenderPayload payload) {
    final iconProps = props.icon.maybe(IconProps.fromJson);
    final icon = VWIcon(
      props: iconProps ??
          IconProps(
            iconData: {
              'pack': 'material',
              'key': 'home',
            },
          ),
      commonProps: commonProps,
      parent: this,
    ).toWidget(payload);

    final selectedIconProps = props.selectedIcon.maybe(IconProps.fromJson);
    final selectedIcon = VWIcon(
      props: selectedIconProps ??
          IconProps(
            iconData: {
              'pack': 'material',
              'key': 'home',
            },
          ),
      commonProps: commonProps,
      parent: this,
    ).toWidget(payload);

    final labelTextProps = props.labelText;

    return Theme(
      data: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            payload.getTextStyle(labelTextProps?.textStyle),
          ),
        ),
      ),
      child: NavigationDestination(
        icon: icon,
        label: payload.evalExpr(labelTextProps?.text) ?? '',
        selectedIcon: selectedIcon,
      ),
    );
  }
}
