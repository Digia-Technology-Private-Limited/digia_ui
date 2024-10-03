import 'package:flutter/widgets.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../internal_widgets/internal_switch.dart';

import '../render_payload.dart';
import '../widget_props/switch_props.dart';

class VWSwitch extends VirtualLeafStatelessWidget<SwitchProps> {
  VWSwitch({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final activeColor = payload.evalExpr<Color>(props.activeColor);
    final inactiveThumbColor =
        payload.evalExpr<Color>(props.inactiveThumbColor);
    final activeTrackColor = payload.evalExpr<Color>(props.activeTrackColor);
    final inactiveTrackColor =
        payload.evalExpr<Color>(props.inactiveTrackColor);

    return InternalSwitch(
      enabled: payload.evalExpr<bool>(props.enabled) ?? false,
      value: payload.evalExpr<bool>(props.value) ?? false,
      activeColor: activeColor,
      inactiveThumbColor: inactiveThumbColor,
      activeTrackColor: activeTrackColor,
      inactiveTrackColor: inactiveTrackColor,
    );
  }
}
