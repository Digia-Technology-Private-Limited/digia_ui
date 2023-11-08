import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';

import 'package:json_annotation/json_annotation.dart';
part 'avatar_props.g.dart';

@JsonEnum()
enum AvatarShape {
  circle,
  square,
}

@JsonSerializable()
class DUIAvatarProps {
  // Radius is only applicable when shape is Square.
  DUICornerRadius? radius;
  AvatarShape _shape;
  String? bgColor;
  String? imageSrc;
  DUITextProps? fallbackText;

  AvatarShape get shape => _shape;

  DUIAvatarProps({
    this.radius,
    this.bgColor,
    this.imageSrc,
    this.fallbackText,
    AvatarShape? shape,
  }) : _shape = shape ?? AvatarShape.circle;

  factory DUIAvatarProps.fromJson(Map<String, dynamic> json) =>
      _$DUIAvatarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIAvatarPropsToJson(this);
}
