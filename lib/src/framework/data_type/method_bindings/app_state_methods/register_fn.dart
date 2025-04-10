import '../../../../config/app_state/reactive_value.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForReactiveField(MethodBindingRegistry registry) {
  registry.registerMethods<ReactiveValue>({
    'set': AppStateVariableSetCommand(),
  });
}
