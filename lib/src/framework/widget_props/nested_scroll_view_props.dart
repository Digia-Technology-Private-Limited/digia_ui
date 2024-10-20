import '../data_type/adapted_types/scroll_controller.dart';
import '../models/types.dart';
import '../utils/types.dart';

class NestedScrollViewProps {
  final ExprOr<AdaptedScrollController>? controller;
  final ExprOr<bool>? enableOverlapAbsorber;

  const NestedScrollViewProps({
    this.controller,
    this.enableOverlapAbsorber,
  });

  factory NestedScrollViewProps.fromJson(JsonLike json) {
    return NestedScrollViewProps(
        controller:
            ExprOr.fromJson<AdaptedScrollController>(json['controller']),
        enableOverlapAbsorber:
            ExprOr.fromJson<bool>(json['enableOverlapAbsorber']));
  }
}
