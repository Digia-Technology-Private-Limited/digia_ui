import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../action_execution_context.dart';
import 'action.dart' as an;

abstract class ActionProcessor<T extends an.Action> {
  ActionExecutionContext? executionContext;

  ActionProcessor({this.executionContext});

  Future<Object?>? execute(
    BuildContext context,
    T action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  });
}
