import 'dart:async';

import '../method_binding_registry.dart';
import 'commands.dart';

void registerMethodCommandsForStreamController(MethodBindingRegistry registry) {
  registry.registerMethods<StreamController<Object?>>({
    'add': StreamControllerAddCommand(),
    // 'addError': StreamControllerAddErrorCommand(),
    'close': StreamControllerCloseCommand(),
  });
}
