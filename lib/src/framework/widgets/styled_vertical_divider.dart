import 'dart:math';

import 'package:flutter/widgets.dart';

import '../../components/border/divider_with_pattern/divider_with_pattern.dart';
import '../base/virtual_leaf_stateless_widget.dart';
import '../models/custom_flutter_types.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWStyledVerticalDivider extends VirtualLeafStatelessWidget<Props> {
  final bool isSimple;
  VWStyledVerticalDivider({
    required super.props,
    required super.commonProps,
    required super.parent,
    super.refName,
    this.isSimple = false,
  });

  @override
  Widget render(RenderPayload payload) {
    if (isSimple) {
      final thickness = payload.eval<double>(props.get('thickness')) ?? 1;
      final lineStyle = To.toLineStyle(props.getString('lineStyle')) ??
          DividerLineStyle.solid;
      final (borderPattern, dashPattern) = getData(lineStyle, thickness);
      return DividerWithPattern(
        axis: Axis.vertical,
        size: payload.eval<double>(props.get('width')),
        thickness: thickness,
        indent: payload.eval<double>(props.get('indent')),
        endIndent: payload.eval<double>(props.get('endIndent')),
        borderPattern: borderPattern,
        dashPattern: dashPattern,
        color: payload.evalColor(props.get('color')),
      );
    } else {
      return DividerWithPattern(
        axis: Axis.vertical,
        size: payload.eval<double>(props.get('width')),
        thickness: payload.eval<double>(props.get('thickness')) ?? 1,
        indent: payload.eval<double>(props.get('indent')),
        endIndent: payload.eval<double>(props.get('endIndent')),
        borderPattern: To.borderPattern(
                payload.eval<String>(props.get('borderPattern.value'))) ??
            BorderPattern.solid,
        strokeCap: To.strokeCap(
                payload.eval<String>(props.get('borderPattern.strokeCap'))) ??
            StrokeCap.butt,
        dashPattern: To.dashPattern(
                payload.eval<String>(props.get('borderPattern.dashPattern'))) ??
            [3, 3],
        color: payload.evalColor(props.get('colorType.color')),
        gradient: To.gradient(
          props.getMap('colorType.gradient'),
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
