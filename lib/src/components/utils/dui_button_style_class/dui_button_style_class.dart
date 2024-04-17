import 'package:digia_ui/src/Utils/util_functions.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
import 'package:digia_ui/src/components/utils/button_shape/dui_button_shape.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_button_style_class.g.dart';

@JsonSerializable()
class DUIButtonStyleClass {
  DUIInsets? padding;
  DUIInsets? margin;
  String? bgColor;
  String? pressedBgColor;
  DUIDisabledButtonStyle? disabledButtonStyle;
  DUIButtonShape? shape;
  String? shadowColor;
  String? alignment;
  double? elevation;

  DUIButtonStyleClass({
    this.padding,
    this.margin,
    this.bgColor,
    this.alignment,
    this.elevation,
    this.disabledButtonStyle,
    this.pressedBgColor,
    this.shape,
    this.shadowColor,
  });

  static DUIButtonStyleClass? fromJson(dynamic json) =>
      _$DUIButtonStyleClassFromJson(json);

  Map<String, dynamic> toJson() => _$DUIButtonStyleClassToJson(this);
}

@JsonSerializable()
class DUIDisabledButtonStyle {
  String? disabledBgColor;
  String? disabledChildColor;
  bool isDisabled;

  DUIDisabledButtonStyle({
    this.disabledBgColor,
    this.disabledChildColor,
    this.isDisabled = false,
  });

  factory DUIDisabledButtonStyle.fromJson(Map<String, dynamic> json) =>
      _$DUIDisabledButtonStyleFromJson(json);

  Map<String, dynamic> toJson() => _$DUIDisabledButtonStyleToJson(this);
}
