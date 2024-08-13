import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:getwidget/components/border/gf_dashed_border.dart';

enum BorderType {
  dotted,
  solid,
  none,
}

class DottedBorderWrapper extends StatelessWidget {
  final Widget child;
  final double? borderWidth;
  final Color? color;
  final BorderRadius borderRadius;
  final String borderType;

  const DottedBorderWrapper({
    super.key,
    required this.child,
    this.borderWidth = 0,
    this.color = Colors.black,
    this.borderRadius = BorderRadius.zero,
    this.borderType = 'none',
  });

  @override
  Widget build(BuildContext context) {
    final BorderType currentBorderType;

    switch (borderType) {
      case 'solid':
        currentBorderType = BorderType.solid;
        break;
      case 'dotted':
        currentBorderType = BorderType.dotted;
        break;
      default:
        currentBorderType = BorderType.none;
    }

    if (currentBorderType == BorderType.none ||
        (borderWidth != null && borderWidth! <= 0)) {
      return child;
    }

    return CustomPaint(
      painter: _BorderPainter(
        color: color ?? Colors.black,
        borderWidth: borderWidth ?? 0,
        borderRadius: borderRadius,
        borderType: currentBorderType,
      ),
      child: ClipPath.shape(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  final Color color;
  final double borderWidth;
  final BorderRadius borderRadius;
  final BorderType borderType;

  _BorderPainter({
    required this.color,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (borderType == BorderType.dotted || borderType == BorderType.solid) {
      final Paint paint = Paint()
        ..color = color
        ..strokeWidth = borderWidth
        ..style = PaintingStyle.stroke;

      Path path;
      switch (borderType) {
        case BorderType.dotted:
          path = _createDottedPath(size);
          canvas.drawPath(path, paint);
          break;
        case BorderType.solid:
          path = _createSolidPath(size);
          canvas.drawPath(path, paint);
          break;
        default:
          break;
      }
    }
  }

  Path _createDottedPath(Size size) {
    final Path path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    ));

    return dashPath(
      path,
      dashArray: CircularIntervalList<double>(<double>[3, 3]),
    );
  }

  Path _createSolidPath(Size size) {
    final Path path = Path();
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    ));

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Path dashPath(Path source, {CircularIntervalList<double>? dashArray}) {
  final Path dest = Path();
  dashArray ??= CircularIntervalList<double>(<double>[10.0, 10.0]);
  for (final PathMetric metric in source.computeMetrics()) {
    double distance = 0.0;
    bool draw = true;
    while (distance < metric.length) {
      double length = dashArray.next;
      if (length > metric.length - distance) {
        length = metric.length - distance;
      }
      draw
          ? dest.addPath(
              metric.extractPath(distance, distance + length), Offset.zero)
          : dest.moveTo(
              metric
                  .extractPath(distance, distance + length)
                  .getBounds()
                  .center
                  .dx,
              metric
                  .extractPath(distance, distance + length)
                  .getBounds()
                  .center
                  .dy);
      distance += length;
      draw = !draw;
    }
  }
  return dest;
}
