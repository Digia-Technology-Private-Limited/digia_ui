import 'package:flutter/widgets.dart';

import '../../base/message_handler.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class PostMessageProcessor extends ActionProcessor<PostMessageAction> {
  PostMessageProcessor({super.logger});

  @override
  Future<Object?>? execute(
    BuildContext context,
    PostMessageAction action,
    ScopeContext? scopeContext,
  ) async {
    final name = action.name;
    final payload = action.payload?.deepEvaluate(scopeContext);

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'name': name,
        'payload': payload,
      },
    );

    final handler = ResourceProvider.maybeOf(context)?.messageHandler;
    if (handler == null) return null;

    handler.handleMessage(DUIMessage(
      context: context,
      name: name,
      payload: payload,
    ));

    return null;
  }
}
