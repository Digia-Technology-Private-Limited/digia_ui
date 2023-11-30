import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'linear_progress_props.g.dart';

@JsonSerializable()
class DUILinearProgressProps {
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

  DUILinearProgressProps({
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

  factory DUILinearProgressProps.fromJson(dynamic json) {
    // print('linearprogress: $json');
    return _$DUILinearProgressPropsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DUILinearProgressPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
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