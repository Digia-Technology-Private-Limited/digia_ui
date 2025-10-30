import '../../adapted_types/story_controller.dart';
import '../base.dart';

class StoryControllerPlayCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    instance.play();
  }
}

class StoryControllerPauseCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    instance.pause();
  }
}

class StoryControllerNextCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    instance.next();
  }
}

class StoryControllerPreviousCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    instance.previous();
  }
}

class StoryControllerJumpToCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    final index = args['index'] as int?;
    if (index != null) {
      instance.jumpTo(index);
    }
  }
}

class StoryControllerMuteCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    instance.mute();
  }
}

class StoryControllerUnMuteCommand extends MethodCommand<AdaptedStoryController> {
  @override
  void run(AdaptedStoryController instance, Map<String, Object?> args) {
    instance.unMute();
  }
}
