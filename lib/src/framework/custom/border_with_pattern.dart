import 'package:flutter/material.dart';
import 'custom_flutter_types.dart';
import 'path_draw.dart';

class BorderWithPattern extends BoxBorder {
  final double strokeWidth;
  final Gradient? gradient;
  final Color color;
  final List<double>? dashPattern;
  final StrokeCap strokeCap;
  final BorderPattern borderPattern;
  final StrokeAlign strokeAlign;

  const BorderWithPattern({
    this.strokeWidth = 0.0,
    this.color = const Color(0x00000000),
    this.gradient,
    this.dashPattern,
    this.strokeCap = StrokeCap.butt,
    this.borderPattern = BorderPattern.solid,
    this.strokeAlign = StrokeAlign.outside,
  });

  @override
  EdgeInsetsGeometry get dimensions {
    switch (strokeAlign) {
      case StrokeAlign.inside:
        return EdgeInsets.all(strokeWidth);
      case StrokeAlign.center:
        return EdgeInsets.all(strokeWidth / 2);
      case StrokeAlign.outside:
        return EdgeInsets.zero;
    }
  }

  @override
  bool get isUniform => true;

  @override
  BoxBorder? add(ShapeBorder other, {bool reversed = false}) {
    if (other is BorderWithPattern) {
      return BorderWithPattern(
        strokeWidth: strokeWidth + other.strokeWidth,
        color: other.gradient != null ? color : other.color,
        dashPattern: other.dashPattern ?? dashPattern,
        strokeCap: other.strokeCap,
        gradient: other.gradient ?? gradient,
        borderPattern: other.borderPattern,
        strokeAlign: other.strokeAlign,
      );
    }
    return null;
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    BorderRadius? borderRadius,
    BoxShape shape = BoxShape.rectangle,
    TextDirection? textDirection,
  }) {
    final Paint paint = Paint()
      ..strokeWidth = strokeWidth
      ..strokeCap = strokeCap
      ..style = PaintingStyle.stroke;

    if (gradient != null) {
      paint.shader = gradient!.createShader(rect);
    } else {
      paint.color = color;
    }

    Path path;
    if (shape == BoxShape.circle) {
      path = _getCirclePath(rect, strokeAlign);
    } else {
      path = _getRRectPath(
          rect, borderRadius ?? const BorderRadius.all(Radius.zero));
    }

    switch (borderPattern) {
      case BorderPattern.dotted:
        path = PathDraw.createDottedPath(path, strokeWidth / 2);
        break;
      case BorderPattern.dashed:
        if (dashPattern != null) {
          path = PathDraw.createDashedPath(path, dashPattern!);
        }
        break;
      case BorderPattern.solid:
        break;
    }
    canvas.drawPath(path, paint);
  }

  Path _getCirclePath(Rect rect, StrokeAlign strokeAlign) {
    double radius;
    switch (strokeAlign) {
      case StrokeAlign.inside:
        radius = (rect.shortestSide / 2) - (strokeWidth / 2);
        break;
      case StrokeAlign.outside:
        radius =
            (rect.shortestSide / 2) + (strokeWidth / 2) - (strokeWidth / 16);
        break;
      case StrokeAlign.center:
        radius = rect.shortestSide / 2;
        break;
    }
    return Path()
      ..addOval(Rect.fromCircle(center: rect.center, radius: radius));
  }

  Path _getRRectPath(Rect rect, BorderRadius borderRadius) {
    RRect rRect = borderRadius.toRRect(rect);
    switch (strokeAlign) {
      case StrokeAlign.inside:
        rRect = rRect.deflate(strokeWidth / 2);
        break;
      case StrokeAlign.outside:
        rRect = rRect.inflate(strokeWidth / 2 - strokeWidth / 16);
        break;
      case StrokeAlign.center:
    }
    return Path()..addRRect(rRect);
  }

  @override
  ShapeBorder scale(double t) {
    return BorderWithPattern(
      strokeWidth: strokeWidth * t,
      dashPattern: dashPattern,
      color: color,
      borderPattern: borderPattern,
      gradient: gradient,
      strokeCap: strokeCap,
    );
  }

  @override
  BorderSide get top => BorderSide(
        color: color,
        width: strokeWidth,
        style: borderPattern == BorderPattern.solid
            ? BorderStyle.solid
            : BorderStyle.none,
      );

  @override
  BorderSide get bottom => top;
}
