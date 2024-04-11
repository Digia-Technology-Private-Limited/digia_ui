import 'package:digia_ui/src/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_icon_button_props.g.dart';

@JsonSerializable()
class DUIIconButtonProps {
  final DUIIconProps? icon;
  final String? iconColor;
  final double? iconSize;
  final DUIInsets? padding;
  final String? alignment;
  final ActionProp? onClick;
  final String? childAlignment;
  final double? elevation;
  final String? backgroundColor;

  DUIIconButtonProps({
    this.icon,
    this.onClick,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.alignment,
    this.childAlignment,
    this.backgroundColor,
    this.elevation,
  });

  factory DUIIconButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIIconButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIIconButtonPropsToJson(this);
}
