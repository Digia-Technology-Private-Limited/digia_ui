import 'package:flutter/widgets.dart';

import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForTextFieldController(MethodBindingRegistry registry) {
  registry.registerMethods<TextEditingController>({
    'setValue': TextFieldControllerSetValueCommand(),
    'clear': TextFieldControllerClearCommand(),
  });
}
