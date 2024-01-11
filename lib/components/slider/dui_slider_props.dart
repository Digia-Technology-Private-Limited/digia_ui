import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_slider_props.g.dart';

@JsonSerializable()
class DUISliderProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  final DUIStyleClass? styleClass;
  final double? value;
  final String? activeColor;
  final String? inactiveColor;
  final double? min;
  final double? max;
  final int? divisions;
  final String? thumbColor;

  DUISliderProps(this.styleClass, this.value, this.activeColor,
      this.inactiveColor, this.min, this.max, this.divisions, this.thumbColor);

  factory DUISliderProps.fromJson(Map<String, dynamic> json) =>
      _$DUISliderPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUISliderPropsToJson(this);
}
