import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import 'text_props.dart';

class NavigationBarItemDefaultProps {
  final String? unselectedType;
  final JsonLike? unselectedIcon;
  final JsonLike? unselectedImage;
  final String? selectedType;
  final JsonLike? selectedIcon;
  final JsonLike? selectedImage;
  final TextProps? labelText;
  final JsonLike? onSelect;
  final ExprOr<bool>? showIf;

  const NavigationBarItemDefaultProps({
    this.unselectedType,
    this.unselectedIcon,
    this.unselectedImage,
    this.selectedType,
    this.selectedIcon,
    this.selectedImage,
    this.labelText,
    this.onSelect,
    this.showIf,
  });

  factory NavigationBarItemDefaultProps.fromJson(JsonLike json) {
    return NavigationBarItemDefaultProps(
      unselectedType: as$<String>(json['unselectedType']),
      unselectedIcon: as$<JsonLike>(json['unselectedIcon']),
      unselectedImage: as$<JsonLike>(json['unselectedImage']),
      selectedType: as$<String>(json['selectedType']),
      selectedIcon: as$<JsonLike>(json['selectedIcon']),
      selectedImage: as$<JsonLike>(json['selectedImage']),
      labelText: TextProps.fromJson(as$<JsonLike>(json['labelText']) ?? {}),
      onSelect: as$<JsonLike>(json['onSelect']),
      showIf: ExprOr.fromJson<bool>(json['showIf']),
    );
  }
}
