import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dezerv_stepper.dart';

part 'dezerv_stepper_props.g.dart';

@JsonSerializable()
class DezervStepperProps {
  final int? currentIndex;
  final Axis? direction;
  final List<DZStep>? steps;
  final bool? showActiveState;
  final double? sidePadding;
  final double? iconRadius;

  DezervStepperProps(
      {this.currentIndex,
      this.direction,
      this.steps,
      this.showActiveState,
      this.iconRadius,
      this.sidePadding});
}
