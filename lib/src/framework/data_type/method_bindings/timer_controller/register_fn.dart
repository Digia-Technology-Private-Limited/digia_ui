import '../../../internal_widgets/timer/controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForTimerController(MethodBindingRegistry registry) {
  registry.registerMethods<TimerController>({
    'start': TimerControllerStartCommand(),
    'resume': TimerControllerResumeCommand(),
    'pause': TimerControllerPauseCommand(),
    'reset': TimerControllerResetCommand(),
  });
}
