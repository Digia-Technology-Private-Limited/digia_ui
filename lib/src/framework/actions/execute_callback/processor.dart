import 'dart:convert';

import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';

import '../../../../digia_ui.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class ExecuteCallbackProcessor extends ActionProcessor<ExecuteCallbackAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) executeActionFlow;

  ExecuteCallbackProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final resolvedArgs =
        convertVariableUpdateToMap(action.argUpdates, scopeContext);

    final actionDescriptor = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'actionName': action.actionName?.evaluate(scopeContext),
        'argUpdates': resolvedArgs,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      details: {
        'actionName': action.actionName?.evaluate(scopeContext),
        'argUpdates': resolvedArgs,
      },
      observabilityContext: observabilityContext,
    );

    // Parse actionFlow from evaluated actionName
    // The actionName should contain the full ActionFlow JSON structure
    final evaluatedActionName = action.actionName?.evaluate(scopeContext);

    // First, check if there's a native Dart callback registered with this name
    // This allows developers to pass callbacks via createComponent's callbacks parameter
    if (evaluatedActionName is String) {
      final callbackRegistry = CallbackProvider.maybeOf(context);
      if (callbackRegistry != null &&
          callbackRegistry.has(evaluatedActionName)) {
        return _executeNativeCallback(
          context: context,
          callbackRegistry: callbackRegistry,
          callbackName: evaluatedActionName,
          resolvedArgs: resolvedArgs,
          actionDescriptor: actionDescriptor,
          id: id,
          parentActionId: parentActionId,
          observabilityContext: observabilityContext,
        );
      }
    }

    // If no native callback found, try to parse as ActionFlow
    ActionFlow? actionFlow;

    if (evaluatedActionName != null) {
      // If evaluatedActionName is already a Map (ActionFlow JSON), use it directly
      if (evaluatedActionName is Map) {
        actionFlow = ActionFlow.fromJson(evaluatedActionName);
      } else if (evaluatedActionName is String) {
        // If it's a string, try to parse it as JSON
        try {
          final parsedJson = json.decode(evaluatedActionName);
          if (parsedJson is Map) {
            actionFlow = ActionFlow.fromJson(parsedJson);
          } else {
            actionFlow = null;
          }
        } catch (e) {
          // JSON parsing failed - emit error and return
          executionContext?.notifyComplete(
            id: id,
            parentActionId: parentActionId,
            descriptor: actionDescriptor,
            error: e,
            stackTrace: StackTrace.current,
            observabilityContext: observabilityContext,
          );
          return null;
        }
      } else {
        actionFlow = null;
      }
    }

    // Handle null actionFlow with early return and logging
    if (actionFlow == null) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: 'actionFlow parsing returned null',
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      return null;
    }

    try {
      final callbackContext = observabilityContext?.forTrigger(
          triggerType: evaluatedActionName.toString());

      final result = await executeActionFlow(
        id: id,
        context,
        actionFlow,
        DefaultScopeContext(
          variables: {'args': resolvedArgs},
          enclosing: scopeContext,
        ),
        parentActionId: parentActionId,
        observabilityContext: callbackContext,
      );

      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );

      return result;
    } catch (error) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );

      rethrow;
    }
  }

  /// Executes a native Dart callback registered via CallbackProvider.
  ///
  /// This method is called when the actionName matches a callback registered
  /// through the `callbacks` parameter of `createComponent`.
  Future<Object?>? _executeNativeCallback({
    required BuildContext context,
    required CallbackRegistry callbackRegistry,
    required String callbackName,
    required Map<String, Object> resolvedArgs,
    required ActionDescriptor actionDescriptor,
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final callback = callbackRegistry.get(callbackName);

    if (callback == null) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: 'Native callback "$callbackName" not found in registry',
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      return null;
    }

    try {
      // Execute the native Dart callback with resolved args
      final result = await callback(resolvedArgs);

      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );

      return result;
    } catch (error) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );

      rethrow;
    }
  }

  Map<String, Object> convertVariableUpdateToMap(
    List<ArgUpdate> updates,
    ScopeContext? scopeContext,
  ) {
    return {
      for (var update in updates)
        update.argName: update.argValue!.evaluate(scopeContext)!
    };
  }
}
