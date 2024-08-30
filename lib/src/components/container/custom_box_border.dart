import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_drawing/path_drawing.dart';

enum BorderPattern {
  solid,
  dotted,
  dashed,
}

enum StrokeAlign {
  inside,
  outside,
  center,
}

class CustomBorder extends BoxBorder {
  final double strokeWidth;
  final Gradient? gradient;
  final StrokeCap strokeCap;
  final List<double>? dashPattern;
  final Color color;
  final BorderPattern borderPattern;
  final StrokeAlign strokeAlign;

  const CustomBorder({
    required this.strokeWidth,
    required this.color,
    this.dashPattern,
    this.strokeCap = StrokeCap.butt,
    this.gradient,
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
      default:
        return EdgeInsets.zero;
    }
  }

  @override
  bool get isUniform => true;

  @override
  BoxBorder? add(ShapeBorder other, {bool reversed = false}) {
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
      case BorderPattern.solid:
        canvas.drawPath(path, paint);
        break;
      case BorderPattern.dotted:
        path = _createDottedPath(path);
        canvas.drawPath(path, paint);
        break;
      case BorderPattern.dashed:
        if (dashPattern != null) {
          path = dashPath(path, dashArray: CircularIntervalList(dashPattern!));
        }
        canvas.drawPath(path, paint);
        break;
    }
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
      default:
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
      default:
    }
    return Path()..addRRect(rRect);
  }

  Path _createDottedPath(Path path) {
    final Path dottedPath = Path();
    final double dashWidth = strokeWidth; // Each dot's diameter
    final double dashSpacing = strokeWidth * 2; // Space between dots

    // Iterate over the entire path and add circular dots
    final PathMetrics pathMetrics = path.computeMetrics();
    for (final PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;

      while (distance < pathMetric.length) {
        final Tangent? tangent = pathMetric.getTangentForOffset(distance);

        if (tangent != null) {
          // Add a circular dot at the current tangent position
          dottedPath.addOval(Rect.fromCircle(
            center: tangent.position,
            radius: dashWidth / 2,
          ));
        }

        // Move the distance forward by the width of the dot + the spacing
        distance += dashWidth + dashSpacing;
      }
    }

    return dottedPath;
  }

  @override
  ShapeBorder scale(double t) {
    return CustomBorder(
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
