import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';

import '../../method_bindings/method_binding_registry.dart';
import '../../state/state_context_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class ControlObjectProcessor extends ActionProcessor<ControlObjectAction> {
  final MethodBindingRegistry registry;

  ControlObjectProcessor({
    required this.registry,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlObjectAction action,
    ScopeContext? scopeContext,
  ) {
    final stateContext =
        StateContextProvider.findStateByName(context, action.stateContextName);

    if (stateContext == null) {
      throw 'Action.controlObject called on a widget which is not wrapped in StateContextProvider';
    }

    final object = stateContext.stateVariables[action.objectName];

    if (object == null) {
      throw 'Object not found in state: ${action.stateContextName}';
    }

    final evaluatedArgs =
        action.args?.map((e) => e?.evaluate(scopeContext)).toList() ?? [];

    registry.execute(object, action.method, evaluatedArgs);

    return null;
  }
}
