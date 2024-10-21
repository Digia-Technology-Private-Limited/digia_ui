import '../../../internal_widgets/async_builder/controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForAsyncController(MethodBindingRegistry registry) {
  registry.registerMethods<AsyncController<Object?>>({
    'invalidate': AsyncControllerInvalidateCommand(),
  });
}
