import 'package:json_annotation/json_annotation.dart';

part 'dui_tab_controller_props.g.dart';

@JsonSerializable()
class DuiTabControllerProps {
  final int? length;
  final Object? initialIndex;
  final dynamic dynamicList;
  final double? animationDuration;
  DuiTabControllerProps(
      {this.dynamicList,
      this.animationDuration,
      this.length,
      this.initialIndex});

  factory DuiTabControllerProps.fromJson(Map<String, dynamic> json) {
    return _$DuiTabControllerPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DuiTabControllerPropsToJson(this);
  }
}
