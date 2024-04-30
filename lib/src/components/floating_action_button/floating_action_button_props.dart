import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'floating_action_button_props.g.dart';

@JsonSerializable()
class DUIFloatingActionButtonProps {
  final Map<String, dynamic>? icon;
  final String? bgColor;
  final bool? enableFeedback;
  final double? elevation;
  final String? fgColor;
  final String? splashColor;
  final ActionProp? onClick;
  final bool? isExtended;

  DUIFloatingActionButtonProps(
      {this.icon,
      this.bgColor,
      this.enableFeedback,
      this.elevation,
      this.fgColor,
      this.splashColor,
      this.onClick,
      this.isExtended});

  factory DUIFloatingActionButtonProps.fromJson(Map<String, dynamic> json) {
    return _$DUIFloatingActionButtonPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DUIFloatingActionButtonPropsToJson(this);
  }
}
