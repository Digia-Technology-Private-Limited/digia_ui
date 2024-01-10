import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_checkbox_props.g.dart';

@JsonSerializable()
class DUICheckboxProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  final DUIStyleClass? styleClass;
  final String? size;
  final String? activeBgColor;
  // final ActionProp? onChanged;
  final bool? value;
  // final Widget? activeIcon;

  DUICheckboxProps(
    this.size,
    this.activeBgColor,
    // this.onChanged,
    this.value,
    this.styleClass,
    // this.activeIcon,
  );

  factory DUICheckboxProps.fromJson(Map<String, dynamic> json) =>
      _$DUICheckboxPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICheckboxPropsToJson(this);
}
