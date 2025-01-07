import 'package:flutter/material.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/icon_props.dart';
import 'icon.dart';

class VWBottomNavigationBarItem extends VirtualLeafStatelessWidget {
  VWBottomNavigationBarItem({
    required super.props,
    super.refName,
  }) : super(
          parent: null,
          commonProps: null,
        );

  @override
  Widget render(RenderPayload payload) {
    final iconProps = props.toProps('icon');
    final icon = VWIcon(
            props: IconProps(
              iconData: iconProps.get('iconData'),
              size: iconProps.getDouble('size'),
              color: iconProps.getString('color'),
            ),
            commonProps: commonProps,
            parent: this)
        .toWidget(payload);

    final selectedIconProps = props.toProps('selectedIcon');
    final selectedIcon = VWIcon(
            props: IconProps(
              iconData: selectedIconProps.get('iconData'),
              size: selectedIconProps.getDouble('size'),
              color: selectedIconProps.getString('color'),
            ),
            commonProps: commonProps,
            parent: this)
        .toWidget(payload);

    final labelTextProps = props.toProps('labelText');

    return Theme(
      data: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            payload.getTextStyle(labelTextProps.get('textStyle')),
          ),
        ),
      ),
      child: NavigationDestination(
        icon: icon,
        label: labelTextProps.getString('text') ?? '',
        selectedIcon: selectedIcon,
      ),
    );
  }
}
