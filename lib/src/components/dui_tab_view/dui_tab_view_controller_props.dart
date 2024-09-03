import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_view_controller_props.g.dart';

@JsonSerializable()
class DuiTabViewControllerProps {
  final int? length;
  final Object? initialIndex;
  DuiTabViewControllerProps({this.length, this.initialIndex});

  factory DuiTabViewControllerProps.fromJson(Map<String, dynamic> json) {
    return _$DuiTabViewControllerPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DuiTabViewControllerPropsToJson(this);
  }
}
