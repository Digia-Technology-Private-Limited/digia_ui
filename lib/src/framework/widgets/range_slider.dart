import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/range_slider.dart';
import '../widget_props/range_slider_props.dart';

class VWRangeSlider extends VirtualLeafStatelessWidget<RangeSliderProps> {
  VWRangeSlider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final min = payload.evalExpr(props.min) ?? 0;
    final max = payload.evalExpr(props.max) ?? 100;
    final startValue = payload.evalExpr(props.startValue) ?? min;
    final endValue = payload.evalExpr(props.endValue) ?? max;

    // Ensure values are within bounds
    final clampedStart = startValue.clamp(min, max).toDouble();
    final clampedEnd = endValue.clamp(min, max).toDouble();

    return InternalRangeSlider(
      min: min.toDouble(),
      max: max.toDouble(),
      values: RangeValues(clampedStart, clampedEnd),
      onChanged: (value) async {
        await payload.executeAction(
          props.onChanged,
          scopeContext: _createExprContext(value.start, value.end),
        );
      },
      activeColor: payload.evalColor(props.activeColor) ?? Colors.blue,
      inactiveColor: payload.evalColor(props.inactiveColor) ?? Colors.grey,
      thumbColor: payload.evalColor(props.thumbColor) ?? Colors.white,
      thumbRadius: payload.evalExpr(props.thumbRadius)?.toDouble() ?? 10.0,
      trackHeight: payload.evalExpr(props.trackHeight)?.toDouble() ?? 4.0,
      // showLabels: true,
      // showValueIndicators: true,
      // orientation: props.orientation,
      divisions:
          payload.evalExpr(props.division)?.toInt() ?? (max - min).toInt(),
    );
  }

  ScopeContext _createExprContext(double? first, double? second) {
    return DefaultScopeContext(
        variables: {'startValue': first, 'endValue': second});
  }
}
