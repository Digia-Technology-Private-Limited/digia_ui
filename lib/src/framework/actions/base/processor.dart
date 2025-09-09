import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../action_execution_context.dart';
import 'action.dart' as an;

// typedef ActionExecutionDetails = ({
//   BuildContext context,
//   ScopeContext? scopeContext,
//   String eventId,
//   String parentId,
// });

abstract class ActionProcessor<T extends an.Action> {
  ActionExecutionContext? executionContext;

  ActionProcessor({this.executionContext});

  // Future<Object?>? execute(T action, ActionExecutionDetails details);
  Future<Object?>? execute(
    BuildContext context,
    T action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  });
}
