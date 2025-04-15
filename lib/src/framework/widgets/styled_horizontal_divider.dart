import 'dart:math';

import 'package:flutter/widgets.dart';

import '../base/virtual_leaf_stateless_widget.dart';
import '../custom/custom_flutter_types.dart';
import '../custom/divider_with_pattern.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/styled_divider_props.dart';

class VWStyledHorizontalDivider
    extends VirtualLeafStatelessWidget<StyledDividerProps> {
  VWStyledHorizontalDivider({
    required super.commonProps,
    required super.parent,
    required super.props,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final thickness = payload.evalExpr<double>(props.thickness) ?? 1;
    final lineStyle = To.toLineStyle(props.lineStyle);
    BorderPattern? borderPattern = To.borderPattern(props.borderPattern);
    List<double>? dashPattern = payload
            .evalExpr<List<dynamic>>(props.dashPattern)
            ?.where((e) => e != null)
            .map((e) {
              try {
                return double.parse(e.toString());
              } catch (e) {
                return null;
              }
            })
            .whereType<double>()
            .toList() ??
        [];
    if (lineStyle != null) {
      final result = getData(lineStyle, thickness);
      borderPattern = result.$1;
      dashPattern = result.$2;
    }

    return DividerWithPattern(
      axis: Axis.horizontal,
      size: payload.evalExpr<double>(props.size?.height),
      thickness: thickness,
      indent: payload.evalExpr<double>(props.indent),
      endIndent: payload.evalExpr<double>(props.endIndent),
      borderPattern: borderPattern ?? BorderPattern.solid,
      strokeCap: To.strokeCap(props.strokeCap) ?? StrokeCap.butt,
      dashPattern: (dashPattern != null && dashPattern.isNotEmpty)
          ? dashPattern
          : [3, 3],
      color: payload.evalColor(payload.evalExpr<String>(props.color)),
      gradient: To.gradient(
        props.gradient,
        evalColor: payload.evalColor,
      ),
    );
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
