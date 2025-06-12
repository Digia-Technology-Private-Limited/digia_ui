import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/types.dart';

class RangeSliderProps {
  // final Axis orientation;
  final ExprOr<double>? min;
  final ExprOr<double>? max;
  final ExprOr<double>? startValue;
  final ExprOr<double>? endValue;
  final ExprOr<String>? activeColor;
  final ExprOr<String>? inactiveColor;
  final ExprOr<String>? thumbColor;
  final ExprOr<double>? thumbRadius;
  final ExprOr<double>? trackHeight;
  final ExprOr<int>? division;

  final ActionFlow? onChanged;

  const RangeSliderProps({
    // this.orientation = Axis.horizontal,
    this.min,
    this.max,
    this.startValue,
    this.endValue,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.trackHeight,
    this.onChanged,
    this.division,
  });

  static RangeSliderProps fromJson(JsonLike json) {
    return RangeSliderProps(
      // orientation: _parseOrientation(json['orientation']),
      min: ExprOr.fromJson<double>(json['min']),
      max: ExprOr.fromJson<double>(json['max']),
      division: ExprOr.fromJson<int>(json['division']),
      startValue: ExprOr.fromJson<double>(json['startValue']),
      endValue: ExprOr.fromJson<double>(json['endValue']),
      activeColor: ExprOr.fromJson<String>(json['activeColor']),
      inactiveColor: ExprOr.fromJson<String>(json['inactiveColor']),
      thumbColor: ExprOr.fromJson<String>(json['thumbColor']),
      thumbRadius: ExprOr.fromJson<double>(json['thumbRadius']),
      trackHeight: ExprOr.fromJson<double>(json['trackHeight']),
      onChanged: ActionFlow.fromJson(json['onChanged']),
    );
  }
}
