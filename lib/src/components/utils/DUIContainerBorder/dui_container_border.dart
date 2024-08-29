import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../container/custom_box_border.dart';
import '../DUIBorder/dui_border.dart';
import '../DUICornerRadius/dui_corner_radius.dart';
import 'border_pattern_class.dart';

part 'dui_container_border.g.dart';

@JsonSerializable()
class DUIContainerBorder extends DUIBorder {
  Map<String, dynamic>? borderGradiant;
  BorderPatternClass? borderType;
  StrokeAlign? strokeAlign;

  DUIContainerBorder();

  factory DUIContainerBorder.fromJson(dynamic json) =>
      _$DUIContainerBorderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DUIContainerBorderToJson(this);
}
