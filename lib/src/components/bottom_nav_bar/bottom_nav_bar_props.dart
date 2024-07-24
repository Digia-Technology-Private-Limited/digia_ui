import 'package:json_annotation/json_annotation.dart';

part 'bottom_nav_bar_props.g.dart';

@JsonSerializable()
class DUIBottomNavigationBarProps {
  final String? backgroundColor;
  final double? duration;
  final double? elevation;
  final double? height;
  final String? indicatorColor;
  final String? shadowColor;
  final String? borderShape;
  final String? surfaceTintColor;
  final String? overlayColor;
  final bool? showLabels;

  DUIBottomNavigationBarProps(
      {this.duration,
      this.elevation,
      this.height,
      this.indicatorColor,
      this.borderShape,
      this.showLabels,
      this.shadowColor,
      this.backgroundColor,
      this.surfaceTintColor,
      this.overlayColor});

  factory DUIBottomNavigationBarProps.fromJson(Map<String, dynamic> json) =>
      _$DUIBottomNavigationBarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIBottomNavigationBarPropsToJson(this);
}
