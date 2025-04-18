import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
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
    Widget icon = VWIcon(
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

    if (props.imageIcon?['imageSrc'] != null) {
      icon = SizedBox(
        height: props.imageIcon?['height'] as double?,
        width: props.imageIcon?['width'] as double?,
        child: VWImage.fromValues(
                imageSrc: props.imageIcon?['imageSrc'] as String?,
                imageFit: props.imageIcon?['fit'] as String?)
            .toWidget(payload),
      );
    }

    final selectedIconProps = props.selectedIcon.maybe(IconProps.fromJson);
    Widget selectedIcon = VWIcon(
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

    if (props.selectedImageIcon?['imageSrc'] != null) {
      selectedIcon = SizedBox(
        height: props.selectedImageIcon?['height'] as double?,
        width: props.selectedImageIcon?['width'] as double?,
        child: VWImage.fromValues(
                imageSrc: props.selectedImageIcon?['imageSrc'] as String?,
                imageFit: props.selectedImageIcon?['fit'] as String?)
            .toWidget(payload),
      );
    }

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
