import '../../adapted_types/story_controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForStoryController(MethodBindingRegistry registry) {
  registry.registerMethods<AdaptedStoryController>({
    'play': StoryControllerPlayCommand(),
    'pause': StoryControllerPauseCommand(),
    'next': StoryControllerNextCommand(),
    'previous': StoryControllerPreviousCommand(),
    'jumpTo': StoryControllerJumpToCommand(),
    'mute': StoryControllerMuteCommand(),
    'unMute': StoryControllerUnMuteCommand(),
  });
}
