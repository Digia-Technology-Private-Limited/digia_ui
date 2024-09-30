import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class CustomScrollViewProps {
  final ExprOr<bool>? isReverse;
  final bool? enableOverlapInjector;
  final String? scrollDirection;
  final bool? allowScroll;

  const CustomScrollViewProps({
    this.isReverse,
    this.enableOverlapInjector,
    this.scrollDirection,
    this.allowScroll,
  });

  factory CustomScrollViewProps.fromJson(JsonLike json) {
    return CustomScrollViewProps(
      isReverse: ExprOr.fromJson<bool>(json['isReverse']),
      enableOverlapInjector: as$<bool>(json['enableOverlapInjector']),
      scrollDirection: as$<String>(json['scrollDirection']),
      allowScroll: as$<bool>(json['scrollPhysics']),
    );
  }
}
