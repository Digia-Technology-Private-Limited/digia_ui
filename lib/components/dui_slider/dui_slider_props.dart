import 'package:json_annotation/json_annotation.dart';
part 'dui_slider_props.g.dart';

@JsonSerializable()
class DUISliderProps {
  double value;
  final bool _enabled;
  bool get enables => _enabled;

  final double _minVal;
  double get minVal => _minVal;

  final double _maxVal;
  double get maxVal => _maxVal;

  int? divisions;
  double? width;

  String? activeColor;
  String? inactiveColor;
  String? thumbColor;

  DUISliderProps({
    bool? enabled,
    double? min,
    double? max,
    this.divisions,
    this.width,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    required this.value,
  })  : _enabled = enabled ?? true,
        _minVal = min ?? 0.0,
        _maxVal = max ?? 1.0;

  factory DUISliderProps.fromJson(dynamic json) =>
      _$DUISliderPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUISliderPropsToJson(this);
}
