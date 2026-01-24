import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_slider.dart';
import '../widget_props/slider_props.dart';

class VWSlider extends VirtualLeafStatelessWidget<SliderProps> {
  VWSlider({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final initialValue = payload.evalExpr(props.value) ?? 30;

    return InternalSlider(
      min: payload.evalExpr(props.min) ?? 0,
      max: payload.evalExpr(props.max) ?? 100,
      divisions: payload.evalExpr(props.division),
      value: initialValue.toDouble(),
      onChanged: (value) async {
        await payload.executeAction(
          props.onChanged,
          scopeContext: _createExprContext(value),
          triggerType: 'onChanged',
        );
      },
      activeColor: payload.evalColorExpr(props.activeColor) ?? Colors.blue,
      inactiveColor: payload.evalColorExpr(props.inactiveColor) ?? Colors.grey,
      thumbColor: payload.evalColorExpr(props.thumbColor) ?? Colors.white,
      thumbRadius: payload.evalExpr(props.thumbRadius)?.toDouble() ?? 10.0,
      trackHeight: payload.evalExpr(props.trackHeight)?.toDouble() ?? 4.0,
    );
  }

  ScopeContext _createExprContext(double? value) {
    return DefaultScopeContext(
      variables: {'value': value},
    );
  }
}
