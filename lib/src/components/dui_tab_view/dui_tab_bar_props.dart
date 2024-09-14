import 'package:json_annotation/json_annotation.dart';

import '../utils/DUIInsets/dui_insets.dart';

part 'dui_tab_bar_props.g.dart';

@JsonSerializable()
class DUITabBarProps {
  final String? dividerColor;
  final double? dividerHeight;
  final double? indicatorWeight;
  final String? indicatorColor;
  final String? indicatorSize;
  final DUIInsets? tabBarPadding;
  final DUIInsets? labelPadding;
  final String? animationType;
  final Map<String, dynamic>? tabBarScrollable;

  DUITabBarProps(
      {this.animationType,
      this.tabBarScrollable,
      this.indicatorSize,
      this.labelPadding,
      this.dividerHeight,
      this.indicatorWeight,
      this.indicatorColor,
      this.dividerColor,
      this.tabBarPadding});

  factory DUITabBarProps.fromJson(Map<String, dynamic> json) {
    return _$DUITabBarPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabBarPropsToJson(this);
  }
}
