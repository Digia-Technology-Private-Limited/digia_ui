import '../actions/base/action_flow.dart';
import '../data_type/adapted_types/story_controller.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class StoryVideoPlayerProps {
  // Video-specific properties
  final ExprOr<String>? videoUrl;
  final ExprOr<bool>? autoPlay;
  final ExprOr<bool>? looping;
  final ExprOr<String>? fit;
  
  // Story-specific properties
  final ExprOr<List<Object>>? dataSource;
  final ExprOr<AdaptedStoryController>? controller;
  final ActionFlow? onComplete;
  final ActionFlow? onSlideDown;
  final ActionFlow? onSlideStart;
  final ActionFlow? onLeftTap;
  final ActionFlow? onRightTap;
  final ActionFlow? onPreviousCompleted;
  final ActionFlow? onStoryChanged;
  final ExprOr<int>? initialIndex;
  final ExprOr<bool>? restartOnCompleted;
  final ExprOr<int>? duration;
  final JsonLike? indicator;

  const StoryVideoPlayerProps({
    this.videoUrl,
    this.autoPlay,
    this.looping,
    this.fit,
    this.dataSource,
    this.controller,
    this.onComplete,
    this.onSlideDown,
    this.onSlideStart,
    this.onLeftTap,
    this.onRightTap,
    this.onPreviousCompleted,
    this.onStoryChanged,
    this.initialIndex,
    this.restartOnCompleted,
    this.duration,
    this.indicator,
  });

  factory StoryVideoPlayerProps.fromJson(JsonLike json) {
    return StoryVideoPlayerProps(
      videoUrl: ExprOr.fromJson<String>(json['videoUrl']),
      autoPlay: ExprOr.fromJson<bool>(json['autoPlay']),
      looping: ExprOr.fromJson<bool>(json['looping']),
      fit: ExprOr.fromJson<String>(json['fit']),
      dataSource: ExprOr.fromJson<List<Object>>(json['dataSource']),
      controller: ExprOr.fromJson<AdaptedStoryController>(json['controller']),
      onComplete: ActionFlow.fromJson(json['onComplete']),
      onSlideDown: ActionFlow.fromJson(json['onSlideDown']),
      onSlideStart: ActionFlow.fromJson(json['onSlideStart']),
      onLeftTap: ActionFlow.fromJson(json['onLeftTap']),
      onRightTap: ActionFlow.fromJson(json['onRightTap']),
      onPreviousCompleted: ActionFlow.fromJson(json['onPreviousCompleted']),
      onStoryChanged: ActionFlow.fromJson(json['onStoryChanged']),
      initialIndex: ExprOr.fromJson<int>(json['initialIndex']),
      restartOnCompleted: ExprOr.fromJson<bool>(json['restartOnCompleted']),
      duration: ExprOr.fromJson<int>(json['duration']),
      indicator: as$<JsonLike>(json['indicator']),
    );
  }
}