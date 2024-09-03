import 'package:json_annotation/json_annotation.dart';

part 'dui_tabview_item_props.g.dart';

@JsonSerializable()
class DUITabViewItem1Props {
  final bool? isScrollable;
  final double? viewportFraction;

  DUITabViewItem1Props({this.isScrollable, this.viewportFraction});

  factory DUITabViewItem1Props.fromJson(Map<String, dynamic> json) {
    return _$DUITabViewItem1PropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUITabViewItem1PropsToJson(this);
  }
}
