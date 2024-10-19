import 'package:flutter/widgets.dart';

import '../../data_type/method_bindings/method_binding_registry.dart';
import '../../expr/scope_context.dart';
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
    final Object? object = action.dataType?.evaluate(scopeContext);

    if (object == null) {
      throw 'Object of type ${action.dataType} not found';
    }

    final evaluatedArgs =
        action.args?.map((k, v) => MapEntry(k, v?.evaluate(scopeContext))) ??
            {};

    registry.execute(object, action.method, evaluatedArgs);

    return null;
  }
}
