import 'dart:convert';

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
    required String eventId,
    required String parentId,
  }) executeActionFlow;

  ExecuteCallbackProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
      BuildContext context, action, ScopeContext? scopeContext,
      {required String eventId, required String parentId}) async {
    final resolvedArgs =
        convertVariableUpdateToMap(action.argUpdates, scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'actionName': action.actionName?.evaluate(scopeContext),
        'argUpdates': resolvedArgs,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    executionContext?.notifyProgress(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      details: {
        'actionName': action.actionName?.evaluate(scopeContext),
        'argUpdates': resolvedArgs,
      },
    );

    // Parse actionFlow from evaluated actionName
    // The actionName should contain the full ActionFlow JSON structure
    final evaluatedActionName = action.actionName?.evaluate(scopeContext);
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
            eventId: eventId,
            parentId: parentId,
            descriptor: desc,
            error: e,
            stackTrace: StackTrace.current,
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
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: 'actionFlow parsing returned null',
        stackTrace: StackTrace.current,
      );
      return null;
    }

    try {
      final result = await executeActionFlow(
        eventId: eventId,
        context,
        actionFlow,
        DefaultScopeContext(
          variables: {'args': resolvedArgs},
          enclosing: scopeContext,
        ),
        parentId: parentId,
      );

      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
      );

      return result;
    } catch (error) {
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
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
