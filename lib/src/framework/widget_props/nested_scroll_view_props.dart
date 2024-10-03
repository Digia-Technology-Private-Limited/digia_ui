import '../models/types.dart';
import '../utils/types.dart';

class NestedScrollViewProps {
  final ExprOr<bool>? enableOverlapAbsorber;

  const NestedScrollViewProps({
    this.enableOverlapAbsorber,
  });

  factory NestedScrollViewProps.fromJson(JsonLike json) {
    return NestedScrollViewProps(
        enableOverlapAbsorber:
            ExprOr.fromJson<bool>(json['enableOverlapAbsorber']));
  }
}
