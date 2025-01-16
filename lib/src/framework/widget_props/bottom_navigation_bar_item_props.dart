import '../actions/base/action_flow.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';
import 'text_props.dart';

class BottomNavigationBarItemProps {
  final JsonLike? icon;
  final JsonLike? selectedIcon;
  final TextProps? labelText;
  final JsonLike? entity;
  final ActionFlow? onPageSelected;

  const BottomNavigationBarItemProps({
    this.icon,
    this.selectedIcon,
    this.labelText,
    this.entity,
    this.onPageSelected,
  });

  factory BottomNavigationBarItemProps.fromJson(JsonLike json) {
    return BottomNavigationBarItemProps(
      icon: as$<JsonLike>(json['icon']),
      selectedIcon: as$<JsonLike>(json['selectedIcon']),
      labelText: TextProps.fromJson(as$<JsonLike>(json['labelText']) ?? {}),
      entity: as$<JsonLike>(json['entity']),
      onPageSelected: ActionFlow.fromJson(json['onPageSelected']),
    );
  }
}
