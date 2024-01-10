import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_dropdown_props.g.dart';

@JsonSerializable()
class DUIDropdownProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  final DUIStyleClass? styleClass;
  final List<Map> items;
  final String borderRadius;
  final String? alignment;
  final String? dropdownColor;
  final String? focusColor;
  final bool? isExpanded;

  DUIDropdownProps(this.borderRadius, this.alignment, this.dropdownColor,
      this.focusColor, this.isExpanded, this.styleClass, this.items);

  factory DUIDropdownProps.fromJson(Map<String, dynamic> json) =>
      _$DUIDropdownPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIDropdownPropsToJson(this);
}
