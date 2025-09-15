import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../digia_ui_scope.dart';
import '../../expr/scope_context.dart';
import '../../message_bus.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class PostMessageProcessor extends ActionProcessor<PostMessageAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    PostMessageAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final name = action.name;
    final payload = action.payload?.deepEvaluate(scopeContext);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'name': name,
        'payload': payload,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'name': name,
        'payload': payload,
      },
      observabilityContext: observabilityContext,
    );

    final messageBus = DigiaUIScope.of(context).messageBus;

    messageBus.send(Message(name: name, payload: payload, context: context));

    executionContext?.notifyComplete(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      error: null,
      stackTrace: null,
      observabilityContext: observabilityContext,
    );

    return null;
  }
}
