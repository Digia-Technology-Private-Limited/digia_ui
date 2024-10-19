import 'dart:async';

import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForStreamController(MethodBindingRegistry registry) {
  registry.registerMethods<StreamController<Object?>>({
    'add': StreamControllerAddCommand(),
    // 'addError': StreamControllerAddErrorCommand(),
    'close': StreamControllerCloseCommand(),
  });
}
