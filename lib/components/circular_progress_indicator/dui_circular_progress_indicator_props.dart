import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DUICircularProgressIndicatorProps {
  double _strokeWidth;
  double get strokeWidth => _strokeWidth;
  double _strokeAlign;
  double get strokeAlign => _strokeAlign;
  double? thickness;
  String? progressColor;
  String? bgColor;
  String? indicatorColor;
  String? strokeCap;
  // For the Animations
  final int _animationDuration;
  int get animationDuration => _animationDuration;
  double? animationBeginLength;
  double? animationEndLength;
  String _curve;
  String get curves => _curve;

  DUICircularProgressIndicatorProps({
    double? strokeWidth,
    double? strokeAlign,
    this.strokeCap,
    this.thickness,
    this.progressColor,
    this.bgColor,
    this.indicatorColor,
    int? animationDuration,
    this.animationBeginLength,
    this.animationEndLength,
    String? curve,
  })  : _animationDuration = animationDuration ?? 5,
        _strokeAlign = strokeAlign ?? 4.0,
        _strokeWidth = strokeWidth ?? 5.0,
        _curve = curve ?? 'linear';

  @override
  String toString() {
    return jsonEncode(this);
  }
}
