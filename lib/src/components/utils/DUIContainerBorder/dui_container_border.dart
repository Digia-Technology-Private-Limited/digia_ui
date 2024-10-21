import 'package:json_annotation/json_annotation.dart';

import '../../../framework/models/custom_flutter_types.dart';
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

  factory DUIContainerBorder.fromJson(Map<String, dynamic> json) =>
      _$DUIContainerBorderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DUIContainerBorderToJson(this);
}
