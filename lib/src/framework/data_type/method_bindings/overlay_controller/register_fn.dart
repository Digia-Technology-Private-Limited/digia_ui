import '../../adapted_types/overlay_controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForOverlayController(
    MethodBindingRegistry registry) {
  registry.registerMethods<AdaptedOverlayController>({
    'show': OverlayControllerShowCommand(),
    'hide': OverlayControllerHideCommand(),
    'toggle': OverlayControllerToggleCommand(),
  });
}
