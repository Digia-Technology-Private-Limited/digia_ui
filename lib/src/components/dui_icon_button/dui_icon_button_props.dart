import 'dart:convert';

import 'package:digia_ui/src/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/src/components/utils/dui_button_style_class/dui_button_style_class.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_icon_button_props.g.dart';

@JsonSerializable()
class DUIIconButtonProps {
  @JsonKey(
      fromJson: DUIButtonStyleClass.fromJson,
      includeToJson: false,
      name: 'String')
  DUIButtonStyleClass? styleClass;
  @JsonKey(
    fromJson: DUIDisabledButtonStyle.fromJson,
    includeToJson: false,
    name: 'disabledButtonStyle')
  DUIDisabledButtonStyle? disabledButtonStyle;

  DUIIconProps? icon;
  ActionFlow? onClick;

  DUIIconButtonProps();

  factory DUIIconButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIIconButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIIconButtonPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
