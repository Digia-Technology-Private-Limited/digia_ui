import 'package:flutter/widgets.dart';

import '../../core/analytics_handler.dart';
import '../../dui_logger.dart';
import '../expr/scope_context.dart';
import '../method_bindings/method_binding_registry.dart';
import '../utils/types.dart';
import 'action_processor_factory.dart';
import 'base/action_flow.dart';

class ActionExecutor {
  final Widget Function(
    BuildContext context,
    String id,
    JsonLike? args,
  ) viewBuilder;
  final Route<Object> Function(
    BuildContext context,
    String id,
    JsonLike? args,
  ) pageRouteBuilder;
  final MethodBindingRegistry bindingRegistry;

  final DUILogger? logger;

  ActionExecutor({
    required this.viewBuilder,
    required this.pageRouteBuilder,
    required this.bindingRegistry,
    this.logger,
  });

  Future<Object?>? execute(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) async {
    AnalyticsHandler.instance.execute(
      context: context,
      events: actionFlow.analyticsData,
      enclosing: scopeContext,
    );

    for (final action in actionFlow.actions) {
      if (!context.mounted) continue;

      final disableAction =
          action.disableActionIf?.evaluate(scopeContext) ?? false;

      if (disableAction) continue;

      final processor = ActionProcessorFactory(
        ActionProcDependencies(
          viewBuilder: viewBuilder,
          executeActionFlow: execute,
          pageRouteBuilder: pageRouteBuilder,
          bindingRegistry: bindingRegistry,
        ),
      ).getProcessor(action);
      await processor.execute(context, action, scopeContext);
    }

    return null;
  }
}
