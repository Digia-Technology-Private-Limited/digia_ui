import 'package:digia_ui/src/components/DUIText/dui_text_style.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_view_props.g.dart';

@JsonSerializable()
class DUITabViewProps {
  final bool? hasTabs;
  final String? dividerColor;
  final String? tabBarPosition;
  final String? selectedLabelColor;
  final String? unselectedLabelColor;
  final double? dividerHeight;
  final bool? isScrollable;
  final String? indicatorColor;
  final double? viewportFraction;
  @JsonKey(fromJson: DUITextStyle.fromJson, includeToJson: false, name: 'selectedLabelStyle')
  DUITextStyle? selectedLabelStyle;
  @JsonKey(fromJson: DUITextStyle.fromJson, includeToJson: false, name: 'unselectedLabelStyle')
  DUITextStyle? unselectedLabelStyle;

  DUITabViewProps(
      {this.hasTabs,
      this.selectedLabelColor,
      this.selectedLabelStyle,
      this.unselectedLabelColor,
      this.unselectedLabelStyle,
      this.dividerHeight,
      this.indicatorColor,
      this.dividerColor,
      this.tabBarPosition,
      required this.isScrollable,
      this.viewportFraction});

  factory DUITabViewProps.fromJson(Map<String, dynamic> json) {
    return _$DUITabViewPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabViewPropsToJson(this);
  }
}
