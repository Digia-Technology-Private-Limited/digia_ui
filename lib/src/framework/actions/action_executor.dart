import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../data_type/method_bindings/method_binding_registry.dart';
import '../expr/scope_context.dart';
import '../utils/types.dart';
import 'action_descriptor.dart';
import 'action_execution_context.dart';
import 'action_processor_factory.dart';
import 'base/action.dart';
import 'base/action_flow.dart';

class ActionExecutor {
  final ActionExecutionContext actionExecutionContext;
  final Widget Function(BuildContext, String, JsonLike?) viewBuilder;
  final Route<Object> Function(BuildContext, String, JsonLike?)
      pageRouteBuilder;
  final MethodBindingRegistry bindingRegistry;

  ActionExecutor({
    required this.actionExecutionContext,
    required this.viewBuilder,
    required this.pageRouteBuilder,
    required this.bindingRegistry,
  });

  Future<Object?>? execute(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    String? id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    // Register all actions as pending
    for (final action in actionFlow.actions) {
      final actionId = ActionId(IdHelper.randomId());
      action.actionId = actionId;

      actionExecutionContext.notifyPending(
        id: actionId.id,
        parentActionId: parentActionId,
        type: action.actionType,
        definition: action.toJson(),
        observabilityContext: observabilityContext,
      );
    }

    for (final action in actionFlow.actions) {
      if (!context.mounted) continue;
      final actionEventId = action.actionId;

      // disabled?
      final disabled = action.disableActionIf?.evaluate(scopeContext) ?? false;
      if (disabled) {
        actionExecutionContext.notifyDisabled(
          id: actionEventId!.id,
          parentActionId: parentActionId,
          descriptor: ActionDescriptor(
            id: actionEventId!.id,
            type: action.actionType,
            definition: action.toJson(),
            resolvedParameters: {},
          ),
          reason: action.disableActionIf?.toString() ?? 'disableActionIf=true',
          observabilityContext: observabilityContext,
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
        actionExecutionContext,
      ).getProcessor(action);

      await processor.execute(
        context,
        action,
        scopeContext,
        id: actionEventId!.id,
        parentActionId: parentActionId,
        observabilityContext: observabilityContext,
      );
    }

    return null;
  }
}
