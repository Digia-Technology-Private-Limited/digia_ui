import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../models/props.dart';
import '../widget_props/icon_props.dart';
import '../widget_props/nav_bar_item_default_props.dart';
import 'icon.dart';

class VWNavigationBarItemDefault
    extends VirtualLeafStatelessWidget<NavigationBarItemDefaultProps> {
  VWNavigationBarItemDefault({
    required super.props,
    super.refName,
  }) : super(
          parent: null,
          commonProps: null,
        );

  @override
  Widget render(RenderPayload payload) {
    final unselectedType = props.unselectedType ?? 'icon';
    final selectedType = props.selectedType ?? 'icon';

    final showIf = props.showIf?.evaluate(payload.scopeContext);
    if (showIf == false) return empty();

    Widget? unselectedWidget;
    if (unselectedType == 'icon') {
      unselectedWidget = VWIcon(
        props: IconProps.fromJson(props.unselectedIcon) ?? IconProps.empty(),
        commonProps: commonProps,
        parent: this,
      ).toWidget(payload);
    } else {
      final image = props.unselectedImage;
      if (image != null) {
        unselectedWidget = VWImage(
          props: Props(image),
          commonProps: commonProps,
          parent: this,
        ).toWidget(payload);
      }
    }

    Widget? selectedWidget;
    if (selectedType == 'icon') {
      selectedWidget = VWIcon(
        props: IconProps.fromJson(props.selectedIcon) ?? IconProps.empty(),
        commonProps: commonProps,
        parent: this,
      ).toWidget(payload);
    } else {
      final image = props.selectedImage;
      if (image != null) {
        selectedWidget = VWImage(
          props: Props(image),
          commonProps: commonProps,
          parent: this,
        ).toWidget(payload);
      }
    }

    return Theme(
      data: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            payload.getTextStyle(props.labelText?.textStyle),
          ),
        ),
      ),
      child: NavigationDestination(
        icon: unselectedWidget ?? empty(),
        label: payload.evalExpr(props.labelText?.text) ?? '',
        selectedIcon: selectedWidget ?? empty(),
      ),
    );
  }
}
