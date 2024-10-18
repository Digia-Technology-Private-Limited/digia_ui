import '../data_type/compex_object.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class CustomScrollViewProps {
  final EitherRefOrValue dataType;

  final ExprOr<bool>? isReverse;
  final String? scrollDirection;
  final bool? allowScroll;

  const CustomScrollViewProps({
    required this.dataType,
    this.isReverse,
    this.scrollDirection,
    this.allowScroll,
  });

  factory CustomScrollViewProps.fromJson(JsonLike json) {
    return CustomScrollViewProps(
      dataType: EitherRefOrValue.fromJson(json['dataType']),
      isReverse: ExprOr.fromJson<bool>(json['isReverse']),
      scrollDirection: as$<String>(json['scrollDirection']),
      allowScroll: as$<bool>(json['scrollPhysics']),
    );
  }
}
