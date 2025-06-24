import 'package:flutter/widgets.dart';

import '../../digia_ui_scope.dart';
import '../../expr/scope_context.dart';
import '../../message_bus.dart';
import '../base/processor.dart';
import 'action.dart';

class PostMessageProcessor extends ActionProcessor<PostMessageAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    PostMessageAction action,
    ScopeContext? scopeContext,
  ) async {
    final name = action.name;
    final payload = action.payload?.deepEvaluate(scopeContext);

    logAction(
      action.actionType.value,
      {
        'name': name,
        'payload': payload,
      },
    );

    final messageBus = DigiaUIScope.of(context).messageBus;

    messageBus.send(Message(name: name, payload: payload, context: context));

    return null;
  }
}
