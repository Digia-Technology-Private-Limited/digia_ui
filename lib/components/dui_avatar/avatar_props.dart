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
  AvatarShape _shape;

  // For AvatarShape.square
  double _side;
  DUICornerRadius? cornerRadius;
  // For AvatarShape.circle
  double _radius;

  // If Image has to be used
  String? imageSrc;
  String? imageFit;
  // Will use Text if image is not provided
  DUITextProps? text;

  // Common props
  String? bgColor;

  double get radius => _radius;
  AvatarShape get shape => _shape;
  double get side => _side;

  DUIAvatarProps({
    this.cornerRadius,
    double? radius,
    double? side,
    this.bgColor,
    this.imageSrc,
    this.text,
    this.imageFit,
    AvatarShape? shape,
  })  : _radius = radius ?? 16.0,
        _side = side ?? 32.0,
        _shape = shape ?? AvatarShape.circle;

  factory DUIAvatarProps.fromJson(Map<String, dynamic> json) {
    // print('Json from config file: $json');
    return _$DUIAvatarPropsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DUIAvatarPropsToJson(this);
}
