import 'package:json_annotation/json_annotation.dart';
part 'dui_slider_props.g.dart';

@JsonSerializable()
class DUISliderProps {
  double value;
  bool _enabled;
  bool get enabled => _enabled;

  double _minVal;
  double get minVal => _minVal;

  double _maxVal;
  double get maxVal => _maxVal;

  int? divisions;
  double? width;

  String? activeColor;
  String? inactiveColor;
  String? thumbColor;

  DUISliderProps({
    bool? enabled,
    double? minVal,
    double? maxVal,
    this.divisions,
    this.width,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    required this.value,
  })  : _enabled = enabled ?? true,
        _minVal = minVal ?? 0.0,
        _maxVal = maxVal ?? 1.0;

  factory DUISliderProps.fromJson(dynamic json) =>
      _$DUISliderPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUISliderPropsToJson(this);
}
