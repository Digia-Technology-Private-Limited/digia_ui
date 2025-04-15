import '../models/types.dart';
import '../utils/types.dart';

class CondtionalItemProps {
  final ExprOr<bool>? condition;

  CondtionalItemProps({this.condition});

  factory CondtionalItemProps.fromJson(JsonLike json) {
    return CondtionalItemProps(
      condition: ExprOr.fromJson<bool>(json['condition']),
    );
  }
}
