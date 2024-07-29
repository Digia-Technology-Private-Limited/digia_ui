import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:getwidget/components/border/gf_dashed_border.dart';

enum BorderType { none, dotted, solid }

enum InputBorderType { outline, underline }

class DottedInputBorder extends InputBorder {
  final InputBorderType inputBorderType;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final BorderType borderType;

  const DottedInputBorder({
    required this.inputBorderType,
    required this.borderSide,
    required this.borderType,
    required this.borderRadius,
  });

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0.0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    switch (borderType) {
      case BorderType.dotted:
        return _createDottedPath(rect);
      case BorderType.solid:
        return _createSolidPath(rect);
      case BorderType.none:
        return Path(); // Return an empty path for no border
    }
  }

  Path _createDottedPath(Rect rect) {
    final Path path = Path();

    if (inputBorderType == InputBorderType.outline) {
      path.addRRect(RRect.fromRectAndCorners(
        rect,
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

    final double bottom = rect.bottom - borderSide.width / 2.0;
    final double left = rect.left;
    final double right = rect.right;
    return dashPath(
      path
        ..moveTo(left, bottom)
        ..lineTo(right, bottom),
      dashArray: CircularIntervalList<double>(<double>[3, 3]),
    );
  }

  Path _createSolidPath(Rect rect) {
    final Path path = Path();
    if (inputBorderType == InputBorderType.outline) {
      path.addRRect(RRect.fromRectAndCorners(
        rect,
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ));
    } else {
      final double bottom = rect.bottom - borderSide.width / 2.0;
      final double left = rect.left;
      final double right = rect.right;
      path
        ..moveTo(left, bottom)
        ..lineTo(right, bottom);
    }

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {double gapExtent = 0.0,
      double gapPercentage = 0.0,
      double? gapStart,
      TextDirection? textDirection}) {
    final Path path = getOuterPath(rect, textDirection: textDirection);
    final Paint paint = borderSide.toPaint();

    canvas.drawPath(path, paint);
  }

  @override
  InputBorder copyWith({BorderSide? borderSide}) {
    return DottedInputBorder(
      inputBorderType: inputBorderType,
      borderSide: borderSide ?? this.borderSide,
      borderType: borderType,
      borderRadius: borderRadius,
    );
  }

  @override
  bool get isOutline => true;

  @override
  InputBorder scale(double t) {
    return DottedInputBorder(
      inputBorderType: inputBorderType,
      borderSide: borderSide.scale(t),
      borderType: borderType,
      borderRadius: borderRadius,
    );
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
