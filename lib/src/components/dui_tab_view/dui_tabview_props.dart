import 'package:json_annotation/json_annotation.dart';

import '../utils/DUIInsets/dui_insets.dart';

part 'dui_tabview_props.g.dart';

@JsonSerializable()
class DUITabView1Props {
  final String? dividerColor;
  final double? dividerHeight;
  final String? indicatorColor;
  final String? indicatorSize;
  final DUIInsets? tabBarPadding;
  final DUIInsets? labelPadding;
  final String? animationType;
  final Map<String, dynamic>? tabBarScrollable;

  DUITabView1Props(
      {this.animationType,
      this.tabBarScrollable,
      this.indicatorSize,
      this.labelPadding,
      this.dividerHeight,
      this.indicatorColor,
      this.dividerColor,
      this.tabBarPadding});

  factory DUITabView1Props.fromJson(Map<String, dynamic> json) {
    return _$DUITabView1PropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabView1PropsToJson(this);
  }
}
