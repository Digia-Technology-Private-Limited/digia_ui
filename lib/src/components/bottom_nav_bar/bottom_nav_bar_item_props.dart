import 'package:json_annotation/json_annotation.dart';

part 'bottom_nav_bar_item_props.g.dart';

@JsonSerializable()
class DUIBottomNavigationBarItemProps {
  final Map<String, dynamic>? labelText;
  final Map<String, dynamic>? icon;
  final Map<String, dynamic>? selectedIcon;
  final String? pageId;
  final Map<String, dynamic>? onPageSelected;

  DUIBottomNavigationBarItemProps(
      {this.labelText,
      this.icon,
      this.selectedIcon,
      this.pageId,
      this.onPageSelected});

  factory DUIBottomNavigationBarItemProps.fromJson(Map<String, dynamic> json) =>
      _$DUIBottomNavigationBarItemPropsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DUIBottomNavigationBarItemPropsToJson(this);
}
