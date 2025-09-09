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
  Future<Object?>? execute(BuildContext context, ControlObjectAction action,
      ScopeContext? scopeContext,
      {required String eventId, required String parentId}) {
    final Object? object = action.dataType?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'dataType': object?.toString(),
        'method': action.method,
      },
    );

    executionContext?.notifyStart(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
    );

    if (object == null) {
      final error = 'Object of type ${action.dataType} not found';
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
      );
      throw error;
    }

    final evaluatedArgs =
        action.args?.map((k, v) => MapEntry(k, v?.evaluate(scopeContext))) ??
            {};

    executionContext?.notifyProgress(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      details: {
        'dataType': object.toString(),
        'args': evaluatedArgs,
        'method': action.method,
      },
    );

    registry.execute(object, action.method, evaluatedArgs);

    executionContext?.notifyComplete(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      error: null,
      stackTrace: null,
    );

    return null;
  }
}
