import '../utils/object_util.dart';
import '../utils/types.dart';

class SpacerProps {
  final int flex;
  const SpacerProps({
    int? flex,
  }) : flex = flex ?? 1;

  factory SpacerProps.fromJson(JsonLike json) {
    return SpacerProps(flex: json['flex']?.to<int>());
  }
}
