import 'package:json_annotation/json_annotation.dart';
part 'circular_progress_bar_props.g.dart';

@JsonSerializable()
class DUICircularProgressBarProps {
  double _strokeWidth;
  double get strokeWidth => _strokeWidth;
  double _strokeAlign;
  double get strokeAlign => _strokeAlign;
  double? thickness;
  String? strokeCap;
  String? bgColor;
  String? indicatorColor;
  // For the Animations
  final int _animationDuration;
  int get animationDuration => _animationDuration;
  double? animationBeginLength;
  double? animationEndLength;
  String _curve;
  String get curves => _curve;

  DUICircularProgressBarProps({
    double? strokeWidth,
    double? strokeAlign,
    this.strokeCap,
    this.thickness,
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

  factory DUICircularProgressBarProps.fromJson(dynamic json) =>
      _$DUICircularProgressBarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICircularProgressBarPropsToJson(this);
}
