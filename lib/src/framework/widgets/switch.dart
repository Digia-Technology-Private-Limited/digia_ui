import 'package:flutter/widgets.dart';
import '../../../digia_ui.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_switch.dart';

import '../widget_props/switch_props.dart';

class VWSwitch extends VirtualLeafStatelessWidget<SwitchProps> {
  VWSwitch({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final activeColor = payload.evalColorExpr(props.activeColor);
    final inactiveThumbColor = payload.evalColorExpr(props.inactiveThumbColor);
    final activeTrackColor = payload.evalColorExpr(props.activeTrackColor);
    final inactiveTrackColor = payload.evalColorExpr(props.inactiveTrackColor);

    return InternalSwitch(
        enabled: payload.evalExpr(props.enabled) ?? false,
        value: payload.evalExpr(props.value) ?? false,
        activeColor: activeColor,
        inactiveThumbColor: inactiveThumbColor,
        activeTrackColor: activeTrackColor,
        inactiveTrackColor: inactiveTrackColor,
        onChanged: (p0) async {
          await payload.executeAction(
            props.onChanged,
            scopeContext: _createExprContext(p0),
            triggerType: 'onChanged',
          );
        });
  }

  ScopeContext _createExprContext(bool value) {
    return DefaultScopeContext(variables: {
      'value': value,
    });
  }
}
