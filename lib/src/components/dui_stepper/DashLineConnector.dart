import 'package:flutter/material.dart';
import 'package:timelines/src/line_painter.dart';
import 'package:timelines/timelines.dart';

class CustomDashedLineConnector extends DashedLineConnector {
  /// Creates a custom dashed line connector with customizable stroke cap.
  ///
  /// The [thickness], [space], [indent], [endIndent], and [strokeCap] must be
  /// null or non-negative.
  const CustomDashedLineConnector({
    super.key,
    super.direction,
    super.thickness,
    super.dash,
    super.gap,
    super.space,
    super.indent,
    super.endIndent,
    super.color,
    super.gapColor,
    this.strokeCap = StrokeCap.butt,
  })  : assert(space == null || space >= 0),
        assert(indent == null || indent >= 0),
        assert(endIndent == null || endIndent >= 0);
  final StrokeCap strokeCap;

  @override
  Widget build(BuildContext context) {
    final direction = getEffectiveDirection(context);
    final space = getEffectiveSpace(context);
    final indent = getEffectiveIndent(context);
    final endIndent = getEffectiveEndIndent(context);
    return SizedBox(
      width: direction == Axis.vertical ? space : null,
      height: direction == Axis.vertical ? null : space,
      child: Center(
        child: Padding(
          padding: direction == Axis.vertical
              ? EdgeInsetsDirectional.only(
                  top: indent,
                  bottom: endIndent,
                )
              : EdgeInsetsDirectional.only(
                  start: indent,
                  end: endIndent,
                ),
          child: CustomPaint(
            painter: DashedLinePainter(
              direction: direction,
              color: getEffectiveColor(context),
              strokeWidth: getEffectiveThickness(context),
              dashSize: dash ?? 1.0,
              gapSize: gap ?? 1.0,
              gapColor: gapColor ?? Colors.transparent,
              strokeCap: strokeCap,
            ),
            child: Container(),
          ),
        ),
      ),
    );
  }
}
