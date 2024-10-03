import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class CustomScrollViewProps {
  final ExprOr<bool>? isReverse;
  final String? scrollDirection;
  final bool? allowScroll;

  const CustomScrollViewProps({
    this.isReverse,
    this.scrollDirection,
    this.allowScroll,
  });

  factory CustomScrollViewProps.fromJson(JsonLike json) {
    return CustomScrollViewProps(
      isReverse: ExprOr.fromJson<bool>(json['isReverse']),
      scrollDirection: as$<String>(json['scrollDirection']),
      allowScroll: as$<bool>(json['scrollPhysics']),
    );
  }
}
