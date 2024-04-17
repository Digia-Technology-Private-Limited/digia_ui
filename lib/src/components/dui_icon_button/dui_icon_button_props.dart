import 'package:digia_ui/src/components/dui_icons/dui_icon_props.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
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

  final DUIIconProps? icon;
  final ActionFlow? onClick;
  final String? childAlignment;
  final double? elevation;
  final String? backgroundColor;

  DUIIconButtonProps({
    this.styleClass,
    this.icon,
    this.onClick,
    this.childAlignment,
    this.elevation,
    this.backgroundColor,
  });

  factory DUIIconButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIIconButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIIconButtonPropsToJson(this);
}
