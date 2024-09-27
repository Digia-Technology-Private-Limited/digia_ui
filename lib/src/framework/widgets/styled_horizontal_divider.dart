import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../components/border/divider_with_pattern/divider_with_pattern.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/custom_flutter_types.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

/// A styled horizontal divider widget that supports custom patterns and gradients.
///
/// You must provide either [horizontalDividerProps] or [styledHorizontalDividerProps].
/// This ensures that the widget can render with the proper divider style and attributes.
class VWStyledHorizontalDivider extends VirtualLeafStatelessWidget<Props> {
  final Props? horizontalDividerProps;
  final Props? styledHorizontalDividerProps;
  VWStyledHorizontalDivider({
    required super.commonProps,
    required super.parent,
    this.horizontalDividerProps,
    this.styledHorizontalDividerProps,
    super.refName,
  })  : assert(
            horizontalDividerProps != null ||
                styledHorizontalDividerProps != null,
            'Either horizontalDividerProps or styledHorizontalDividerProps must not be null.'),
        super(
          props: styledHorizontalDividerProps ??
              horizontalDividerProps ??
              Props.empty(),
        );

  @override
  Widget render(RenderPayload payload) {
    if (props.isEmpty) {
      return empty();
    }
    if (horizontalDividerProps != null) {
      final thickness = payload.eval<double>(props.get('thickness')) ?? 1;
      final lineStyle = To.toLineStyle(props.getString('lineStyle')) ??
          DividerLineStyle.solid;
      final (borderPattern, dashPattern) = getData(lineStyle, thickness);
      return DividerWithPattern(
        axis: Axis.horizontal,
        size: payload.eval<double>(props.get('height')),
        thickness: thickness,
        indent: payload.eval<double>(props.get('indent')),
        endIndent: payload.eval<double>(props.get('endIndent')),
        borderPattern: borderPattern,
        dashPattern: dashPattern,
        color: payload.evalColor(props.get('color')),
      );
    } else {
      return DividerWithPattern(
        axis: Axis.horizontal,
        size: payload.eval<double>(props.get('height')),
        thickness: payload.eval<double>(props.get('thickness')),
        indent: payload.eval<double>(props.get('indent')),
        endIndent: payload.eval<double>(props.get('endIndent')),
        borderPattern: To.borderPattern(
              payload.eval<String>(props.get('borderPattern.value')),
            ) ??
            BorderPattern.solid,
        strokeCap: To.strokeCap(
                payload.eval<String>(props.get('borderPattern.strokeCap'))) ??
            StrokeCap.butt,
        dashPattern: To.dashPattern(
                payload.eval<String>(props.get('borderPattern.dashPattern'))) ??
            [3, 3],
        color: payload.evalColor(props.get('colorType.color')),
        gradient: To.gradient(
          props.getMap('colorType.gradiant'),
          evalColor: payload.evalColor,
        ),
      );
    }
  }

  (BorderPattern, List<double>?) getData(
      DividerLineStyle style, double thickenss) {
    switch (style) {
      case DividerLineStyle.dashed:
        return (
          BorderPattern.dashed,
          [(5 * max(thickenss, 1)), 2 * max(thickenss, 1)]
        );
      case DividerLineStyle.dotted:
        return (BorderPattern.dashed, [max(thickenss, 1), max(thickenss, 1)]);
      case DividerLineStyle.dashDotted:
        return (
          BorderPattern.dashed,
          [
            3 * max(thickenss, 1),
            max(thickenss, 1),
            max(thickenss, 1),
            max(thickenss, 1)
          ]
        );
      default:
        return (BorderPattern.solid, null);
    }
  }
}
