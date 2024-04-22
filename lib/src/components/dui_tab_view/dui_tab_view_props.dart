import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_view_props.g.dart';

@JsonSerializable()
class DUITabViewProps {
  final bool? hasTabs;
  // final String? activeTabColor;
  // final String? tabBarPosition;
  // final bool? allowScroll;
  // final String? tabsBackgroundColor;

  DUITabViewProps({
    required this.hasTabs,
    // this.activeTabColor,
    // this.tabBarPosition,
    // this.allowScroll,
    // this.tabsBackgroundColor
  });

  factory DUITabViewProps.fromJson(Map<String, dynamic> json) {
    return _$DUITabViewPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabViewPropsToJson(this);
  }
}
