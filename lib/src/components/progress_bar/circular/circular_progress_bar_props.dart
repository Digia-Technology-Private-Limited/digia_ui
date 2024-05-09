import 'package:json_annotation/json_annotation.dart';
part 'circular_progress_bar_props.g.dart';

@JsonSerializable()
class DUICircularProgressBarProps {
  double strokeWidth;
  double strokeAlign;
  double? thickness;
  String? strokeCap;
  String? bgColor;
  String? indicatorColor;
  // Animation Props
  final int animationDuration;
  double? animationBeginLength;
  double? animationEndLength;
  String? curve;

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
    this.curve,
  })  : animationDuration = animationDuration ?? 5,
        strokeAlign = strokeAlign ?? 4.0,
        strokeWidth = strokeWidth ?? 5.0;

  factory DUICircularProgressBarProps.fromJson(dynamic json) => _$DUICircularProgressBarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICircularProgressBarPropsToJson(this);
}
