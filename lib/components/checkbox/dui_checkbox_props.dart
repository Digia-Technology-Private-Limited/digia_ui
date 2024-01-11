import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_checkbox_props.g.dart';

@JsonSerializable()
class DUICheckboxProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  final DUIStyleClass? styleClass;
  final String? size;
  final String? activeColor;
  // final ActionProp? onChanged;
  final bool? value;

  DUICheckboxProps(
    this.size,
    this.activeColor,
    // this.onChanged,
    this.value,
    this.styleClass,
  );

  factory DUICheckboxProps.fromJson(Map<String, dynamic> json) =>
      _$DUICheckboxPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICheckboxPropsToJson(this);
}
