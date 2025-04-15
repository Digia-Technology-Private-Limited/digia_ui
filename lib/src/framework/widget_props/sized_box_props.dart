import '../utils/object_util.dart';
import '../utils/types.dart';

class SizedBoxProps {
  final double? width;
  final double? height;

  const SizedBoxProps({
    this.width,
    this.height,
  });

  factory SizedBoxProps.fromJson(JsonLike json) {
    return SizedBoxProps(
      width: json['width']?.to<double>(),
      height: json['height']?.to<double>(),
    );
  }
}
