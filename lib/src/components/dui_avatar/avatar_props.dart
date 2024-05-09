import 'package:digia_ui/src/Utils/basic_shared_utils/num_decoder.dart';
import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:json_annotation/json_annotation.dart';

part 'avatar_props.g.dart';

// @JsonEnum()
// enum AvatarShape {
//   circle,
//   square,
// }

sealed class AvatarShape {
  const AvatarShape();

  static AvatarShape? fromJson(Map<String, dynamic>? json) {
    if (json == null || json['value'] == null) return null;

    switch (json['value']) {
      case 'circle':
        return AvatarCircleShape(radius: NumDecoder.toDouble(json['radius']));

      case 'square':
        return AvatarSquareShape(
            sideLength: NumDecoder.toDouble(json['side']),
            cornerRadius: DUICornerRadius.fromJson(json['cornerRadius']));
    }

    return null;
  }

  static Map<String, dynamic>? toJson(AvatarShape? shape) {
    return switch (shape) {
      AvatarCircleShape(:final radius) => {'value': 'circle', 'radius': radius},
      AvatarSquareShape(:final sideLength, :final cornerRadius) => {
          'value': 'square',
          'side': sideLength,
          'cornerRadius': cornerRadius?.toJson()
        },
      _ => null
    };
  }
}

class AvatarSquareShape extends AvatarShape {
  final double sideLength;
  final DUICornerRadius? cornerRadius;

  const AvatarSquareShape({double? sideLength, this.cornerRadius}) : sideLength = sideLength ?? 32.0;
}

class AvatarCircleShape extends AvatarShape {
  final double radius;
  const AvatarCircleShape({
    double? radius,
  }) : radius = radius ?? 16.0;
}

@JsonSerializable()
class DUIAvatarProps {
  @JsonKey(fromJson: AvatarShape.fromJson, toJson: AvatarShape.toJson)
  AvatarShape? shape;
  // If Image has to be used
  String? imageSrc;
  String? imageFit;
  // Will use Text if image is not provided
  DUITextProps? text;

  String? bgColor;

  DUIAvatarProps({this.bgColor, this.imageSrc, this.text, this.imageFit, this.shape});

  factory DUIAvatarProps.fromJson(Map<String, dynamic> json) => _$DUIAvatarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIAvatarPropsToJson(this);
}
