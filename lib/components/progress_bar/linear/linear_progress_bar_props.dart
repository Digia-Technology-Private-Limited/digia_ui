import 'package:json_annotation/json_annotation.dart';

part 'linear_progress_bar_props.g.dart';

@JsonSerializable()
class DUILinearProgressBarProps {
  double? width;
  double? thickness;
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

  DUILinearProgressBarProps({
    this.width,
    this.thickness,
    this.borderRadius,
    this.bgColor,
    this.indicatorColor,
    int? animationDuration,
    this.animationBeginLength,
    this.animationEndLength,
    String? curve,
  })  : _animationDuration = animationDuration ?? 5,
        _curve = curve ?? 'linear';

  factory DUILinearProgressBarProps.fromJson(dynamic json) =>
      _$DUILinearProgressBarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUILinearProgressBarPropsToJson(this);
}
