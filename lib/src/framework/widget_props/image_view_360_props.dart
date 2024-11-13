import '../models/types.dart';
import '../utils/types.dart';

class ImageView360Props {
  final ExprOr<List>? imageUrlList;
  final ExprOr<String>? rotationDirection;
  final ExprOr<int>? frameChangeDuration;
  final ExprOr<int>? swipeSensitivity;
  final ExprOr<bool>? autoRotate;
  final ExprOr<bool>? allowSwipeToRotate;

  const ImageView360Props({
    this.imageUrlList,
    this.allowSwipeToRotate,
    this.autoRotate,
    this.rotationDirection,
    this.frameChangeDuration,
    this.swipeSensitivity,
  });

  factory ImageView360Props.fromJson(JsonLike json) {
    return ImageView360Props(
      imageUrlList: ExprOr.fromJson<List>(json['imageUrlList']),
      rotationDirection: ExprOr.fromJson<String>(json['rotationDirection']),
      swipeSensitivity: ExprOr.fromJson<int>(json['swipeSensitivity']),
      frameChangeDuration: ExprOr.fromJson<int>(json['frameChangeDuration']),
      autoRotate: ExprOr.fromJson<bool>(json['autoRotate']),
      allowSwipeToRotate: ExprOr.fromJson<bool>(json['allowSwipeToRotate']),
    );
  }
}
