import '../data_type/compex_object.dart';
import '../models/types.dart';
import '../utils/types.dart';

class NestedScrollViewProps {
  final ExprOr<bool>? enableOverlapAbsorber;
  final EitherRefOrValue dataType;

  const NestedScrollViewProps(
      {this.enableOverlapAbsorber, required this.dataType});

  factory NestedScrollViewProps.fromJson(JsonLike json) {
    return NestedScrollViewProps(
        dataType: EitherRefOrValue.fromJson(json['dataType']),
        enableOverlapAbsorber:
            ExprOr.fromJson<bool>(json['enableOverlapAbsorber']));
  }
}
