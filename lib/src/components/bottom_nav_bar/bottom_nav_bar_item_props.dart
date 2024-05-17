import 'package:json_annotation/json_annotation.dart';

part 'bottom_nav_bar_item_props.g.dart';

@JsonSerializable()
class DUIBottomNavigationBarItemProps {
  final String? label;
  final Map<String, dynamic>? icon;
  final Map<String, dynamic>? selectedIcon;
  final String? pageId;

  DUIBottomNavigationBarItemProps(
      {this.label, this.icon, this.selectedIcon, this.pageId});

  factory DUIBottomNavigationBarItemProps.fromJson(Map<String, dynamic> json) =>
      _$DUIBottomNavigationBarItemPropsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DUIBottomNavigationBarItemPropsToJson(this);
}
