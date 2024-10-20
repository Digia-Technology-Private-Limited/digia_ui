import '../../adapted_types/scroll_controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForScrollController(MethodBindingRegistry registry) {
  registry.registerMethods<AdaptedScrollController>({
    'jumpTo': ScrollControllerJumpToCommand(),
    'animateTo': ScrollControllerAnimateToCommand(),
  });
}
