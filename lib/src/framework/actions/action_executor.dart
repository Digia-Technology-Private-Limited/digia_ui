import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter/widgets.dart';

import '../../core/analytics_handler.dart';
import '../../dui_logger.dart';
import '../utils/types.dart';
import 'action_processor_factory.dart';
import 'base/action_flow.dart';

class ActionExecutor {
  final Widget Function(
    BuildContext context,
    String id,
    JsonLike? args,
  ) viewBuilder;
  final Route<Object> Function(BuildContext context, String id, JsonLike? args)
      pageRouteBuilder;

  final DUILogger? logger;

  ActionExecutor({
    required this.viewBuilder,
    required this.pageRouteBuilder,
    this.logger,
  });

  Future<Object?>? execute(
    BuildContext context,
    ActionFlow actionFlow,
    ExprContext? exprContext,
  ) async {
    AnalyticsHandler.instance.execute(
      context: context,
      events: actionFlow.analyticsData,
      enclosing: exprContext,
    );

    for (final action in actionFlow.actions) {
      if (!context.mounted) continue;

      final disableAction =
          action.disableActionIf?.evaluate(exprContext) ?? false;

      if (disableAction) continue;

      final processor = ActionProcessorFactory(
        ActionProcDependencies(
          viewBuilder: viewBuilder,
          executeActionFlow: execute,
          pageRouteBuilder: pageRouteBuilder,
        ),
      ).getProcessor(action);
      await processor.execute(context, action, exprContext);
    }

    return null;
  }
}
