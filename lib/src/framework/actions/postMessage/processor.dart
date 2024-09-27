import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../page/message_handler.dart';
import '../../page/resource_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class PostMessageProcessor implements ActionProcessor<PostMessageAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    PostMessageAction action,
    ExprContext? exprContext,
  ) async {
    final name = action.name;
    final payload = action.payload?.deepEvaluate(exprContext);

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
