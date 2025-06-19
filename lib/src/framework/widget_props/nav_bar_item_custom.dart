import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class NavigationBarItemCustomProps {
  final JsonLike? onSelect;
  final ExprOr<bool>? showIf;

  const NavigationBarItemCustomProps({
    this.onSelect,
    this.showIf,
  });

  factory NavigationBarItemCustomProps.fromJson(JsonLike json) {
    return NavigationBarItemCustomProps(
      onSelect: as$<JsonLike>(json['onSelect']),
      showIf: ExprOr.fromJson<bool>(json['showIf']),
    );
  }
}
