import '../models/types.dart';
import '../utils/types.dart';

class OpacityProps {
  final ExprOr<bool>? alwaysIncludeSemantics;
  final ExprOr<double>? opacity;

  const OpacityProps({
    this.opacity,
    this.alwaysIncludeSemantics,
  });

  factory OpacityProps.fromJson(JsonLike json) {
    return OpacityProps(
      opacity: ExprOr.fromJson<double>(json['opacity']),
      alwaysIncludeSemantics:
          ExprOr.fromJson<bool>(json['alwaysIncludeSemantics']),
    );
  }
}
