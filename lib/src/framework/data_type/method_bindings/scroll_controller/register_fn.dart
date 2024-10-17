import 'package:flutter/widgets.dart';

import '../method_binding_registry.dart';
import 'commands.dart';

registerMethodCommandsForScrollController(MethodBindingRegistry registry) {
  registry.registerMethods<ScrollController>({
    'jumpTo': ScrollControllerJumpToCommand(),
    'animateTo': ScrollControllerAnimateToCommand(),
  });
}
