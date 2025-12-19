import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../models/props.dart';
import '../utils/num_util.dart';
import '../widget_props/nav_bar_item_default_props.dart';

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
    final showIf = props.showIf?.evaluate(payload.scopeContext);
    if (showIf == false) return empty();

    Widget? unselectedWidget;
    var image = props.unselectedImage;
    if (image != null) {
      unselectedWidget = SizedBox(
        height: NumUtil.toDouble(props.unselectedImage?['height']),
        width: NumUtil.toDouble(props.unselectedImage?['width']),
        child: VWImage(
          props: Props(image),
          commonProps: commonProps,
          parent: this,
        ).toWidget(payload),
      );
    }

    Widget? selectedWidget;

    image = props.selectedImage;
    if (image != null) {
      selectedWidget = SizedBox(
        height: NumUtil.toDouble(props.selectedImage?['height']),
        width: NumUtil.toDouble(props.selectedImage?['width']),
        child: VWImage(
          props: Props(image),
          commonProps: commonProps,
          parent: this,
        ).toWidget(payload),
      );
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
        icon: unselectedWidget ?? Icon(Icons.home),
        label: payload.evalExpr(props.labelText?.text) ?? '',
        selectedIcon: selectedWidget ?? Icon(Icons.home),
      ),
    );
  }
}
