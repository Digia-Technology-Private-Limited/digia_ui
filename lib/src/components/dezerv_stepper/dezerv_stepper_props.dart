import 'package:json_annotation/json_annotation.dart';

import 'dz_step.dart';

part 'dezerv_stepper_props.g.dart';

@JsonSerializable()
class DezervStepperProps {
  final double? currentIndex;
  final List<DZStep>? steps;
  final bool? showActiveState;
  final double? sidePadding;
  final double? iconRadius;
  final double? firstTitleWidth;
  final double? lastTitleWidth;
  final String? circleColor;

  DezervStepperProps(
      {this.currentIndex,
      this.steps,
      this.showActiveState,
      this.iconRadius,
      this.sidePadding,
      this.firstTitleWidth,
      this.lastTitleWidth,
      this.circleColor});

  factory DezervStepperProps.fromJson(Map<String, dynamic> json) =>
      _$DezervStepperPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DezervStepperPropsToJson(this);
}
