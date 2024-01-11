import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';
import '../utils/DUIInsets/dui_insets.dart';
part 'dui_container_props.g.dart';

@JsonSerializable()
class DUIContainerProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  final DUIStyleClass? styleClass;
  final String? placeHolder;
  final String? width;
  final String? height;
  final String? alignment;
  final DUIInsets margin;
  final DUIInsets padding;
  final String? color;
  final bool? hasBorder;
  final String? borderRadius;
  final String? borderColor;
  final double? borderWidth;
  final String? imageURL;
  final double? imageOpacity;

  DUIContainerProps(
      this.styleClass,
      this.width,
      this.height,
      this.alignment,
      this.margin,
      this.padding,
      this.color,
      this.hasBorder,
      this.borderRadius,
      this.borderColor,
      this.borderWidth,
      this.imageURL,
      this.imageOpacity,
      this.placeHolder);

  factory DUIContainerProps.fromJson(Map<String, dynamic> json) =>
      _$DUIContainerPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIContainerPropsToJson(this);
}
