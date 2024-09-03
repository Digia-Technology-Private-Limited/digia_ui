import 'package:json_annotation/json_annotation.dart';

import '../DUIText/dui_text_style.dart';
import '../utils/DUIInsets/dui_insets.dart';

part 'dui_tabview_props.g.dart';

@JsonSerializable()
class DUITabView1Props {
  final String? dividerColor;
  final String? selectedLabelColor;
  final String? unselectedLabelColor;
  final double? dividerHeight;
  final String? indicatorColor;
  final String? indicatorSize;
  final DUIInsets? tabBarPadding;
  final DUIInsets? labelPadding;
  final Object? initialIndex;
  @JsonKey(
      fromJson: DUITextStyle.fromJson,
      includeToJson: false,
      name: 'selectedLabelStyle')
  DUITextStyle? selectedLabelStyle;
  @JsonKey(
      fromJson: DUITextStyle.fromJson,
      includeToJson: false,
      name: 'unselectedLabelStyle')
  DUITextStyle? unselectedLabelStyle;

  DUITabView1Props(
      {this.indicatorSize,
      this.initialIndex,
      this.labelPadding,
      this.selectedLabelColor,
      this.selectedLabelStyle,
      this.unselectedLabelColor,
      this.unselectedLabelStyle,
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
