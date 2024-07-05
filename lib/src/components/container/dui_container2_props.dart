import 'package:json_annotation/json_annotation.dart';

import '../utils/DUIBorder/dui_border.dart';
import '../utils/DUIInsets/dui_insets.dart';
import 'dui_decoration_image.dart';

part 'dui_container2_props.g.dart';

@JsonSerializable()
class DUIContainer2Props {
  final String? width;
  final String? height;
  final String? maxHeight;
  final String? minHeight;
  final String? maxWidth;
  final String? minWidth;
  final String? childAlignment;
  final DUIInsets? margin;
  final DUIInsets? padding;
  final String? color;
  final DUIBorder? border;
  final DUIDecorationImage? decorationImage;
  final String? shape;
  final String? boxFit;
  final Map<String, dynamic>? gradiant;

  DUIContainer2Props(
    this.width,
    this.height,
    this.maxHeight,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
    this.childAlignment,
    this.margin,
    this.padding,
    this.color,
    this.border,
    this.decorationImage,
    this.shape,
    this.boxFit,
    this.gradiant,
  );

  factory DUIContainer2Props.fromJson(Map<String, dynamic> json) =>
      _$DUIContainer2PropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIContainer2PropsToJson(this);
}
