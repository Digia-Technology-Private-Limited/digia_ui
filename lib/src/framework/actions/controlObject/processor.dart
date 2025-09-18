import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../data_type/method_bindings/method_binding_registry.dart';
import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
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
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) {
    final Object? object = action.dataType?.evaluate(scopeContext);

    final actionDescriptor = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'dataType': object?.toString(),
        'method': action.method,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      observabilityContext: observabilityContext,
    );

    if (object == null) {
      final error = 'Object of type ${action.dataType} not found';
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      throw error;
    }

    final evaluatedArgs =
        action.args?.map((k, v) => MapEntry(k, v?.evaluate(scopeContext))) ??
            {};

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: actionDescriptor,
      details: {
        'dataType': object.toString(),
        'args': evaluatedArgs,
        'method': action.method,
      },
      observabilityContext: observabilityContext,
    );

    Object? error;
    StackTrace? stackTrace;
    try {
      registry.execute(object, action.method, evaluatedArgs);
    } catch (e, s) {
      error = e;
      stackTrace = s;
      rethrow;
    } finally {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: actionDescriptor,
        error: error,
        stackTrace: stackTrace,
        observabilityContext: observabilityContext,
      );
    }

    return null;
  }
}
