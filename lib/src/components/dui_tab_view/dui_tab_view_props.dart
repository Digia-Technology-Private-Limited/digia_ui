import 'package:json_annotation/json_annotation.dart';

import '../DUIText/dui_text_style.dart';
import '../utils/DUIInsets/dui_insets.dart';

part 'dui_tab_view_props.g.dart';

@JsonSerializable()
class DUITabViewProps {
  final bool? hasTabs;
  // final String? dividerColor;
  final String? tabBarPosition;
  final String? iconPosition;
  final String? selectedLabelColor;
  final String? unselectedLabelColor;
  // final double? dividerHeight;
  final bool? isScrollable;
  // final String? indicatorColor;
  // final String? indicatorSize;
  final double? viewportFraction;
  final DUIInsets? tabBarPadding;
  final DUIInsets? labelPadding;
  final Object? initialIndex;
  final  Map<String,dynamic>? tabBarScrollable;
  final  Map<String,dynamic>? buttonProps;
  final Map<String,dynamic>? indicatorProps;
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

  DUITabViewProps(
      {this.iconPosition,
      this.tabBarScrollable,
      this.buttonProps,
      this.indicatorProps,
      this.hasTabs,
      // this.indicatorSize,
      this.initialIndex,
      this.labelPadding,
      this.selectedLabelColor,
      this.selectedLabelStyle,
      this.unselectedLabelColor,
      this.unselectedLabelStyle,
      // this.dividerHeight,
      // this.indicatorColor,
      // this.dividerColor,
      this.tabBarPosition,
      required this.isScrollable,
      this.viewportFraction,
      this.tabBarPadding});

  factory DUITabViewProps.fromJson(Map<String, dynamic> json) {
    return _$DUITabViewPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabViewPropsToJson(this);
  }
}
