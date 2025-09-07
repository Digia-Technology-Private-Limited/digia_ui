import 'package:flutter/widgets.dart';

import '../data_type/method_bindings/method_binding_registry.dart';
import '../expr/scope_context.dart';
import '../utils/id_util.dart';
import '../utils/types.dart';
import 'action_descriptor.dart';
import 'action_execution_context.dart';
import 'action_processor_factory.dart';
import 'base/action_flow.dart';

class ActionExecutor {
  final ActionExecutionContext executionContext;
  final Widget Function(BuildContext, String, JsonLike?) viewBuilder;
  final Route<Object> Function(BuildContext, String, JsonLike?)
      pageRouteBuilder;
  final MethodBindingRegistry bindingRegistry;

  ActionExecutor({
    required this.executionContext,
    required this.viewBuilder,
    required this.pageRouteBuilder,
    required this.bindingRegistry,
  });

  Future<Object?>? execute(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    // Use the provided parentId if it's not null, otherwise create a new flowId
    final flowId = parentId.isNotEmpty ? parentId : IdGen.newFlowId();

    // Register all actions as pending
    for (final action in actionFlow.actions) {
      final actionId = IdGen.newActionId();
      action.actionId = actionId;

      executionContext.notifyPending(
        eventId: actionId.id,
        parentId: flowId,
        type: action.actionType,
        definition: action.toJson(),
      );
    }

    for (final action in actionFlow.actions) {
      if (!context.mounted) continue;
      final actionEventId = action.actionId;

      // disabled?
      final disabled = action.disableActionIf?.evaluate(scopeContext) ?? false;
      if (disabled) {
        executionContext.notifyDisabled(
          eventId: actionEventId!.id,
          parentId: flowId,
          descriptor: ActionDescriptor(
            id: actionEventId!.id,
            type: action.actionType,
            definition: action.toJson(),
            resolvedParameters: {},
          ),
          reason: 'disableActionIf=true',
        );
        continue;
      }

      final processor = ActionProcessorFactory(
        ActionProcDependencies(
          viewBuilder: viewBuilder,
          executeActionFlow: execute,
          pageRouteBuilder: pageRouteBuilder,
          bindingRegistry: bindingRegistry,
        ),
        executionContext,
      ).getProcessor(action);

      await processor.execute(
        context,
        action,
        scopeContext,
        eventId: actionEventId!.id,
        parentId: flowId,
      );
    }

    return null;
  }
}
