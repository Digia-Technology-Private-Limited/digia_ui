import 'package:flutter/widgets.dart';

import '../../../core/analytics_handler.dart';
import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class FireEventProcessor extends ActionProcessor<FireEventAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) executeActionFlow;

  FireEventProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    FireEventAction action,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'events': action.events.map((e) => e.toJson()).toList(),
        'eventCount': action.events.length,
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
        'events': action.events.map((e) => e.toJson()).toList(),
        'eventCount': action.events.length,
      },
    );

    AnalyticsHandler.instance.execute(
      context: context,
      events: action.events,
      enclosing: scopeContext,
    );

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
