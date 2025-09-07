import 'package:flutter/widgets.dart';

import '../../digia_ui_scope.dart';
import '../../expr/scope_context.dart';
import '../../message_bus.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class PostMessageProcessor extends ActionProcessor<PostMessageAction> {
  @override
  Future<Object?>? execute(BuildContext context, PostMessageAction action,
      ScopeContext? scopeContext,
      {required String eventId, required String parentId}) async {
    final name = action.name;
    final payload = action.payload?.deepEvaluate(scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'name': name,
        'payload': payload,
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
        'name': name,
        'payload': payload,
      },
    );

    final messageBus = DigiaUIScope.of(context).messageBus;

    messageBus.send(Message(name: name, payload: payload, context: context));

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
