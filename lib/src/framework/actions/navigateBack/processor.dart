import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackProcessor extends ActionProcessor<NavigateBackAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final maybe = action.maybe?.evaluate(scopeContext) ?? false;
    final result = {
      'data': action.result?.deepEvaluate(scopeContext),
    };

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'maybe': maybe,
        'result': result,
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
        'maybe': maybe,
        'result': result,
        'canPop': Navigator.of(context).canPop(),
      },
    );

    Object? navigationResult;
    if (maybe) {
      navigationResult = Navigator.of(context).maybePop(result);
    } else {
      Navigator.of(context).pop(result);
      navigationResult = null;
    }

    executionContext?.notifyComplete(
      eventId: eventId,
      parentId: parentId,
      descriptor: desc,
      error: null,
      stackTrace: null,
    );

    return navigationResult;
  }
}
