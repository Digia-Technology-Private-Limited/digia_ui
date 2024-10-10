import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_view_content_props.g.dart';

@JsonSerializable()
class DUITabViewContentProps {
  final bool? isScrollable;
  final double? viewportFraction;
  final bool? keepTabsAlive;

  DUITabViewContentProps({
    this.isScrollable,
    this.viewportFraction,
    this.keepTabsAlive,
  });

  factory DUITabViewContentProps.fromJson(Map<String, dynamic> json) {
    return _$DUITabViewContentPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabViewContentPropsToJson(this);
  }
}
