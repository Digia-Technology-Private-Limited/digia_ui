import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_view_item_props.g.dart';

@JsonSerializable()
class DUITabViewItemProps {
  final DUITextProps? title;
  final Map<String, dynamic>? icon;

  DUITabViewItemProps(this.title, this.icon);

  factory DUITabViewItemProps.fromJson(Map<String, dynamic> json) =>
      _$DUITabViewItemPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITabViewItemPropsToJson(this);
}
