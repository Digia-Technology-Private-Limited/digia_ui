import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/types.dart';

class SliderProps {
  final ExprOr<double>? min;
  final ExprOr<double>? max;
  final ExprOr<double>? value;
  final ExprOr<String>? activeColor;
  final ExprOr<String>? inactiveColor;
  final ExprOr<String>? thumbColor;
  final ExprOr<double>? thumbRadius;
  final ExprOr<double>? trackHeight;
  final ExprOr<int>? division;

  final ActionFlow? onChanged;

  const SliderProps({
    this.min,
    this.max,
    this.value,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.trackHeight,
    this.onChanged,
    this.division,
  });

  static SliderProps fromJson(JsonLike json) {
    return SliderProps(
      min: ExprOr.fromJson<double>(json['min']),
      max: ExprOr.fromJson<double>(json['max']),
      division: ExprOr.fromJson<int>(json['division']),
      value: ExprOr.fromJson<double>(json['value']),
      activeColor: ExprOr.fromJson<String>(json['activeColor']),
      inactiveColor: ExprOr.fromJson<String>(json['inactiveColor']),
      thumbColor: ExprOr.fromJson<String>(json['thumbColor']),
      thumbRadius: ExprOr.fromJson<double>(json['thumbRadius']),
      trackHeight: ExprOr.fromJson<double>(json['trackHeight']),
      onChanged: ActionFlow.fromJson(json['onChanged']),
    );
  }
}
