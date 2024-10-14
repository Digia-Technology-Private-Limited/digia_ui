import '../../internal_widgets/async_builder/controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForAsyncController(MethodBindingRegistry registry) {
  registry.registerMethods<AsyncController>({
    'invalidate': AsyncControllerInvalidateCommand(),
  });
}
