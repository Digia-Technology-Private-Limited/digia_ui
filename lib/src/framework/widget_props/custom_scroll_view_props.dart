import '../data_type/adapted_types/scroll_controller.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class CustomScrollViewProps {
  final ExprOr<AdaptedScrollController>? controller;

  final ExprOr<bool>? isReverse;
  final String? scrollDirection;
  final bool? allowScroll;

  const CustomScrollViewProps({
    this.controller,
    this.isReverse,
    this.scrollDirection,
    this.allowScroll,
  });

  factory CustomScrollViewProps.fromJson(JsonLike json) {
    return CustomScrollViewProps(
      controller: ExprOr.fromJson<AdaptedScrollController>(json['controller']),
      isReverse: ExprOr.fromJson<bool>(json['isReverse']),
      scrollDirection: as$<String>(json['scrollDirection']),
      allowScroll: as$<bool>(json['scrollPhysics']),
    );
  }
}
