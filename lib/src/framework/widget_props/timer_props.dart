import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

const String _countDownTimerTypeValue = 'countDown';

class TimerProps {
  final ExprOr<int>? duration;
  final ExprOr<int>? updateInterval;
  final String _timerType;
  final ExprOr<int>? initialValue;
  final ActionFlow? onTick;
  final ActionFlow? onTimerEnd;

  bool get isCountDown => _timerType == _countDownTimerTypeValue;

  const TimerProps({
    this.duration,
    this.updateInterval,
    String? timerType,
    this.initialValue,
    this.onTick,
    this.onTimerEnd,
  }) : _timerType = timerType ?? _countDownTimerTypeValue;

  factory TimerProps.fromJson(JsonLike json) {
    return TimerProps(
      duration: ExprOr.fromJson<int>(json['duration']),
      updateInterval: ExprOr.fromJson<int>(json['updateInterval']),
      timerType: as$<String>(json['timerType']),
      initialValue: ExprOr.fromJson<int>(json['startingPoint']),
      onTick: ActionFlow.fromJson(json['onTick']),
      onTimerEnd: ActionFlow.fromJson(json['onTimerEnd']),
    );
  }
}
