import '../utils/object_util.dart';
import '../utils/types.dart';

class FlexFitProps {
  final String? flexFitType;
  final int? flexValue;

  const FlexFitProps({
    this.flexFitType,
    this.flexValue,
  });

  factory FlexFitProps.fromJson(JsonLike json) {
    return FlexFitProps(
      flexFitType: json['flexFitType']?.as$<String>(),
      flexValue: json['flexValue']?.to<int>(),
    );
  }
}
