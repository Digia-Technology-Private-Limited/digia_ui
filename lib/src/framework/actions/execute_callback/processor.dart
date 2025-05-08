import 'package:flutter/material.dart';

import '../../../../digia_ui.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class ExecuteCallbackProcessor extends ActionProcessor<ExecuteCallbackAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  ExecuteCallbackProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
      BuildContext context, action, ScopeContext? scopeContext) {
    final actionFlow = ActionFlow.fromJson(
      action.actionName.evaluate(scopeContext),
    );

    DUIFactory().configProvider.getComponentDefinition('componentId').argDefs?[''];

    return executeActionFlow(
        context,
        actionFlow!,
        DefaultScopeContext(
          variables: convertVariableUpdateToMap(action.updates),
          enclosing: scopeContext,
        ));
  }

  Map<String, Map<String, dynamic>> convertVariableUpdateToMap(
      List<VariableUpdate> updates) {
    return {for (var update in updates) update.actionName: update.toJson()};
  }
}
