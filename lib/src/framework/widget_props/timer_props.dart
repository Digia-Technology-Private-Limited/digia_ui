import '../actions/base/action_flow.dart';
import '../data_type/compex_object.dart';
import '../utils/types.dart';

class TimerProps {
  final EitherRefOrValue dataType;
  final ActionFlow? onTick;
  final ActionFlow? onTimerEnd;

  const TimerProps({
    required this.dataType,
    this.onTick,
    this.onTimerEnd,
  });

  factory TimerProps.fromJson(JsonLike json) {
    return TimerProps(
      dataType: EitherRefOrValue.fromJson(json['dataType']),
      onTick: ActionFlow.fromJson(json['onTick']),
      onTimerEnd: ActionFlow.fromJson(json['onTimerEnd']),
    );
  }
}
