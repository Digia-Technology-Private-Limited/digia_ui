import '../utils/object_util.dart';
import '../utils/types.dart';

class PositionedProps {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? width;
  final double? height;

  PositionedProps({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.width,
    this.height,
  });

  factory PositionedProps.fromJson(JsonLike json) {
    return PositionedProps(
      top: json['top']?.to<double>(),
      bottom: json['bottom']?.to<double>(),
      left: json['left']?.to<double>(),
      right: json['right']?.to<double>(),
      width: json['width']?.to<double>(),
      height: json['height']?.to<double>(),
    );
  }
}
