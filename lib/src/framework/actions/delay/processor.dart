import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class DelayProcessor extends ActionProcessor<DelayAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    DelayAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final durationInMs = action.durationInMs?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'durationInMs': durationInMs,
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
        'durationInMs': durationInMs,
        'durationIsNull': durationInMs == null,
      },
    );

    if (durationInMs != null) {
      await Future<void>.delayed(Duration(milliseconds: durationInMs));
    }

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
