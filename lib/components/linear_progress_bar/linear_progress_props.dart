import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LinearProgressProps {
  double? width;
  double? minHeight;
  double? borderRadius;
  String? bgColor;
  String? indicatorColor;

  // For the Animations
  final int _animationDuration;
  int get animationDuration => _animationDuration;
  double? animationBeginLength;
  double? animationEndLength;
  String _curve;
  String get curves => _curve;

  LinearProgressProps({
    this.width,
    this.minHeight,
    this.borderRadius,
    this.bgColor,
    this.indicatorColor,
    int? animationDuration,
    this.animationBeginLength,
    this.animationEndLength,
    String? curve,
  })  : _animationDuration = animationDuration ?? 5,
        _curve = curve ?? 'linear';
}

/*
  easeInCubic,
  easeInExpo,
  easeOutBack,
  easeInOutCirc,
  easeInOutCubic,
  easeInOutCubicEmphasized,
  easeInOutExpo,
  easeInOutQuad,
  easeInOutQuart,
  easeInOutQuint,
  easeInOutSine,
  easeInQuad,
  easeInQuart,
  easeInQuint,
  easeInSine,
  easeInToLinear,
  easeOutCirc,
  easeOutCubic,
  easeOutExpo,
  easeOutQuad,
  easeOutQuart,
  easeOutQuint,
  easeOutSine,
  elasticInOut,
  elasticIn,
  elasticOut,
  fastEaselnToSlowOut,
  fastLinearToSlowEasIn,
  fastOutSlowIn,
  bounceIn,
  bounceOut,
  bounceInOut,
  linearToEaseOut,
  slowMiddle,

*/