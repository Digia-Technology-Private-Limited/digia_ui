import 'package:flutter/widgets.dart';

import '../../../core/analytics_handler.dart';
import '../../expr/scope_context.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class FireEventProcessor extends ActionProcessor<FireEventAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  FireEventProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    FireEventAction action,
    ScopeContext? scopeContext,
  ) async {
    AnalyticsHandler.instance.execute(
      context: context,
      events: action.events,
      enclosing: scopeContext,
    );
    return null;
  }
}
