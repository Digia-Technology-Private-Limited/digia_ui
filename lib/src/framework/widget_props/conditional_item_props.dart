import '../models/types.dart';
import '../utils/types.dart';

class ConditionalItemProps {
  final ExprOr<bool>? condition;

  ConditionalItemProps({this.condition});

  factory ConditionalItemProps.fromJson(JsonLike json) {
    return ConditionalItemProps(
      condition: ExprOr.fromJson<bool>(json['condition']),
    );
  }
}
