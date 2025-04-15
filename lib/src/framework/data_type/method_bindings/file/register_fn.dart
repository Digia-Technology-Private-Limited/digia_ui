import '../../adapted_types/file.dart';
import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForFile(MethodBindingRegistry registry) {
  registry.registerMethods<AdaptedFile>({
    'setNull': FileSetNullCommand(),
  });
}
