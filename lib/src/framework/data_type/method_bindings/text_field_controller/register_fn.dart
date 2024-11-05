import '../../adapted_types/text_editing_controller.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForTextFieldController(
    MethodBindingRegistry registry) {
  registry.registerMethods<AdaptedTextEditingController>({
    'setValue': TextFieldControllerSetValueCommand(),
    'clear': TextFieldControllerClearCommand(),
  });
}
