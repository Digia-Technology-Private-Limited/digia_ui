import '../models/types.dart';
import '../utils/types.dart';

class SafeAreaProps {
  final ExprOr<bool>? left;
  final ExprOr<bool>? top;
  final ExprOr<bool>? right;
  final ExprOr<bool>? bottom;

  const SafeAreaProps({
    this.left,
    this.top,
    this.right,
    this.bottom,
  });

  factory SafeAreaProps.fromJson(JsonLike json) {
    return SafeAreaProps(
      left: ExprOr.fromJson<bool>(json['left']),
      top: ExprOr.fromJson<bool>(json['top']),
      right: ExprOr.fromJson<bool>(json['right']),
      bottom: ExprOr.fromJson<bool>(json['bottom']),
    );
  }
}
