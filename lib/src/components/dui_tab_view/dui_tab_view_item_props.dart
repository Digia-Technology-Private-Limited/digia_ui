import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_view_item_props.g.dart';

@JsonSerializable()
class DUITabViewItemProps {
  final String? title;

  DUITabViewItemProps(this.title);

  factory DUITabViewItemProps.fromJson(Map<String, dynamic> json) =>
      _$DUITabViewItemPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITabViewItemPropsToJson(this);
}
