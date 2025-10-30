import 'package:digia_expr/digia_expr.dart';
import '../../../components/story/story.dart';

class AdaptedStoryController extends FlutterStoryController
    implements ExprInstance {
  AdaptedStoryController();

  @override
  Object? getField(String name) => switch (name) {
        'isPaused' => storyStatus == StoryAction.pause,
        'isMuted' => storyStatus == StoryAction.mute,
        _ => null,
      };
}
