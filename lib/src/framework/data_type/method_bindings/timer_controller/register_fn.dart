import '../../../internal_widgets/timer/controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForTimerController(MethodBindingRegistry registry) {
  registry.registerMethods<TimerController>({
    'start': TimerControllerStartCommand(),
    'resume': TimerControllerResumeCommand(),
    'pause': TimerControllerPauseCommand(),
    'reset': TimerControllerResetCommand(),
  });
}
