import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

part 'dash_painter.dart';

class DottedBorder extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets borderPadding;
  final double strokeWidth;
  final Color color;
  final Gradient? gradient;
  final List<double> dashPattern;
  final BorderType borderType;
  final BorderRadius borderRadius;
  final StrokeCap strokeCap;
  final PathBuilder? customPath;
  final StackFit stackFit;
  final BorderPattern borderPattern;

  DottedBorder({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.gradient,
    this.strokeWidth = 1,
    this.borderType = BorderType.Rect,
    this.dashPattern = const <double>[3, 1],
    this.padding = const EdgeInsets.all(2),
    this.borderPadding = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.zero),
    this.strokeCap = StrokeCap.butt,
    this.customPath,
    this.stackFit = StackFit.loose,
    this.borderPattern = BorderPattern.dashed,
  }) {
    assert(_isValidDashPattern(dashPattern), 'Invalid dash pattern');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: stackFit,
      children: <Widget>[
        Padding(
          padding: padding,
          child: child,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: DashedPainter(
                padding: borderPadding,
                strokeWidth: strokeWidth,
                borderRadius: borderRadius,
                color: color,
                gradient: gradient,
                borderType: borderType,
                dashPattern: dashPattern,
                customPath: customPath,
                strokeCap: strokeCap,
                borderStyle: borderPattern,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Compute if [dashPattern] is valid. The following conditions need to be met
  /// * Cannot be null or empty
  /// * If [dashPattern] has only 1 element, it cannot be 0
  bool _isValidDashPattern(List<double>? dashPattern) {
    Set<double>? _dashSet = dashPattern?.toSet();
    if (_dashSet == null) return false;
    if (_dashSet.length == 1 && _dashSet.elementAt(0) == 0.0) return false;
    if (_dashSet.isEmpty) return false;
    return true;
  }
}

/// The different supported BorderTypes
enum BorderType { Circle, RRect, Rect, Oval }

enum BorderPattern {
  dashed,
  dotted,
  solid,
}
