import 'package:flutter/material.dart';

import 'custom_flutter_types.dart';
import 'path_draw.dart';

class DividerWithPattern extends StatelessWidget {
  final double? size;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;
  final Axis axis;
  final Gradient? gradient;
  final BorderPattern borderPattern;
  final StrokeCap strokeCap;
  final List<double>? dashPattern;

  const DividerWithPattern({
    super.key,
    this.size,
    this.thickness = 1.0,
    this.indent,
    this.endIndent,
    this.color = Colors.black,
    this.axis = Axis.horizontal,
    this.gradient,
    this.borderPattern = BorderPattern.solid,
    this.strokeCap = StrokeCap.butt,
    this.dashPattern,
  });

  @override
  Widget build(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    final double size = this.size ?? dividerTheme.space ?? 16;
    final double thickness = this.thickness ??
        dividerTheme.thickness ??
        DividerTheme.of(context).thickness ??
        0.0;
    final double indent = this.indent ?? dividerTheme.indent ?? 0.0;
    final double endIndent = this.endIndent ?? dividerTheme.endIndent ?? 0.0;

    final Color effectiveColor = color ??
        DividerTheme.of(context).color ??
        Theme.of(context).dividerColor;
    return LayoutBuilder(builder: (context, constraints) {
      final double maxSize = axis == Axis.horizontal
          ? constraints.maxWidth
          : constraints.maxHeight;
      return Padding(
        padding: (axis == Axis.horizontal)
            ? EdgeInsetsDirectional.only(
                start: indent,
                end: endIndent,
              )
            : EdgeInsetsDirectional.only(top: indent, bottom: endIndent),
        child: SizedBox(
          height: axis == Axis.horizontal ? size : null,
          width: axis == Axis.vertical ? size : null,
          child: Center(
            child: CustomPaint(
              size: axis == Axis.horizontal
                  ? Size(maxSize, thickness)
                  : Size(thickness, maxSize),
              painter: _PatternPainter(
                color: effectiveColor,
                gradient: gradient,
                borderPattern: borderPattern,
                strokeCap: strokeCap,
                dashPattern: dashPattern,
                strokeWidth: thickness,
                axis: axis,
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _PatternPainter extends CustomPainter {
  final Color color;
  final Gradient? gradient;
  final BorderPattern borderPattern;
  final StrokeCap strokeCap;
  final List<double>? dashPattern;
  final double strokeWidth;
  final Axis axis;

  _PatternPainter({
    required this.color,
    this.gradient,
    required this.borderPattern,
    required this.strokeCap,
    this.dashPattern,
    this.axis = Axis.horizontal,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    Path path = axis == Axis.horizontal
        ? (Path()
          ..moveTo(0, size.height / 2)
          ..lineTo(size.width, size.height / 2))
        : (Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width / 2, size.height));

    switch (borderPattern) {
      case BorderPattern.dotted:
        path = PathDraw.createDottedPath(path, strokeWidth / 2);
        break;
      case BorderPattern.dashed:
        if (dashPattern != null) {
          path = PathDraw.createDashedPath(path, dashPattern ?? [3, 3]);
        }
        break;
      case BorderPattern.solid:
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PatternPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.gradient != gradient ||
        oldDelegate.borderPattern != borderPattern ||
        oldDelegate.strokeCap != strokeCap ||
        oldDelegate.dashPattern != dashPattern ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.axis != axis;
  }
}
