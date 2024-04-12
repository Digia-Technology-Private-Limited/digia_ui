import 'dart:convert';

import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/src/components/utils/dui_button_style_class/dui_button_style_class.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'button.props.g.dart';

@JsonSerializable()
class DUIButtonProps {
  @JsonKey(
      fromJson: DUIButtonStyleClass.fromJson,
      includeToJson: false,
      name: 'style')
  DUIButtonStyleClass? styleClass;

  // String? shape;
  late DUITextProps text;
  DUIIconProps? rightIcon;
  DUIIconProps? leftIcon;
  bool? disabled;
  ActionFlow? onClick;

  DUIButtonProps();

  factory DUIButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIButtonPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
