import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class StoryProps {
  final ActionFlow? onSlideDown;
  final ActionFlow? onSlideStart;
  final ActionFlow? onLeftTap;
  final ActionFlow? onRightTap;
  final ActionFlow? onCompleted;
  final ActionFlow? onPreviousCompleted;
  final ActionFlow? onStoryChanged;
  final JsonLike? indicator;
  final ExprOr<int>? initialIndex;
  final ExprOr<bool>? restartOnCompleted;

  const StoryProps({
    this.onSlideDown,
    this.onSlideStart,
    this.onLeftTap,
    this.onRightTap,
    this.onCompleted,
    this.onPreviousCompleted,
    this.onStoryChanged,
    this.indicator,
    this.initialIndex,
    this.restartOnCompleted,
  });

  factory StoryProps.fromJson(JsonLike json) {
    return StoryProps(
      onSlideDown: ActionFlow.fromJson(json['onSlideDown']),
      onSlideStart: ActionFlow.fromJson(json['onSlideStart']),
      onLeftTap: ActionFlow.fromJson(json['onLeftTap']),
      onRightTap: ActionFlow.fromJson(json['onRightTap']),
      onCompleted: ActionFlow.fromJson(json['onCompleted']),
      onPreviousCompleted: ActionFlow.fromJson(json['onPreviousCompleted']),
      onStoryChanged: ActionFlow.fromJson(json['onStoryChanged']),
      indicator: as$<JsonLike>(json['indicator']),
      initialIndex: ExprOr.fromJson<int>(json['initialIndex']),
      restartOnCompleted: ExprOr.fromJson<bool>(json['restartOnCompleted']),
    );
  }
}


