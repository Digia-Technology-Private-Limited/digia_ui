import 'package:digia_expr/digia_expr.dart';
import 'package:flutter_story_presenter/flutter_story_presenter.dart';

class AdaptedStoryController extends FlutterStoryController implements ExprInstance {
  AdaptedStoryController();

  @override
  Object? getField(String name) => switch (name) {
        'storyStatus' => storyStatus.toString(),
        'jumpIndex' => jumpIndex,
        'isPlaying' => storyStatus == StoryAction.play,
        'isPaused' => storyStatus == StoryAction.pause,
        'isMuted' => storyStatus == StoryAction.mute,
        _ => null,
      };
}
