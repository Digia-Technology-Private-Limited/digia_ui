import 'package:json_annotation/json_annotation.dart';

part 'linear_progress_bar_props.g.dart';

@JsonSerializable()
class DUILinearProgressBarProps {
  double? width;
  double? thickness;
  double? borderRadius;
  String? bgColor;
  String? indicatorColor;

  // Animation Props
  final int animationDuration;
  double? animationBeginLength;
  double? animationEndLength;
  String curve;

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
  })  : animationDuration = animationDuration ?? 5,
        curve = curve ?? 'linear';

  factory DUILinearProgressBarProps.fromJson(dynamic json) =>
      _$DUILinearProgressBarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUILinearProgressBarPropsToJson(this);
}
