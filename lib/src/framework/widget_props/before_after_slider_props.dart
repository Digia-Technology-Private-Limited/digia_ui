import '../models/types.dart';
import '../utils/types.dart';

class BeforeAfterSliderProps {
  final ExprOr<double>? height;
  final ExprOr<double>? width;
  final ExprOr<double>? thumbHeight;
  final ExprOr<double>? thumbWidth;
  final ExprOr<double>? trackWidth;
  final ExprOr<double>? thumbPosition;
  final ExprOr<bool>? hideThumb;
  final ExprOr<String>? direction;
  final ExprOr<String>? trackColor;
  final ExprOr<String>? thumbColor;

  const BeforeAfterSliderProps({
    this.height,
    this.width,
    this.thumbHeight,
    this.thumbWidth,
    this.trackWidth,
    this.thumbPosition,
    this.hideThumb,
    this.direction,
    this.trackColor,
    this.thumbColor,
  });

  factory BeforeAfterSliderProps.fromJson(JsonLike json) {
    return BeforeAfterSliderProps(
      thumbHeight: ExprOr.fromJson<double>(json['thumbHeight']),
      height: ExprOr.fromJson<double>(json['height']),
      thumbPosition: ExprOr.fromJson<double>(json['thumbPosition']),
      thumbWidth: ExprOr.fromJson<double>(json['thumbWidth']),
      trackWidth: ExprOr.fromJson<double>(json['trackWidth']),
      width: ExprOr.fromJson<double>(json['width']),
      direction: ExprOr.fromJson<String>(json['direction']),
      thumbColor: ExprOr.fromJson<String>(json['thumbColor']),
      trackColor: ExprOr.fromJson<String>(json['trackColor']),
      hideThumb: ExprOr.fromJson<bool>(json['hideThumb']),
    );
  }
}
