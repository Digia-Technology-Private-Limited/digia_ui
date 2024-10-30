import 'package:flutter/widgets.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateToPageProcessor extends ActionProcessor<NavigateToPageAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  final Route<Object> Function(
    BuildContext context,
    String id,
    JsonLike? args,
  ) pageRouteBuilder;

  NavigateToPageProcessor({
    required this.executeActionFlow,
    required this.pageRouteBuilder,
    super.logger,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateToPageAction action,
    ScopeContext? scopeContext,
  ) async {
    final pageId = action.pageId;
    if (pageId == null) {
      throw ArgumentError('Null value', 'pageId');
    }

    final removePreviousScreensInStack =
        action.shouldRemovePreviousScreensInStack;
    final routeNametoRemoveUntil =
        action.routeNametoRemoveUntil?.evaluate(scopeContext);

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'pageId': pageId,
        'pageArgs': action.pageArgs,
        'waitForResult': action.waitForResult,
        'shouldRemovePreviousScreensInStack': removePreviousScreensInStack,
        'routeNametoRemoveUntil': routeNametoRemoveUntil,
        'onResult': action.onResult,
      },
    );

    final navigatorKey = ResourceProvider.maybeOf(context)?.navigatorKey;
    Object? result = await NavigatorHelper.push(
      context,
      navigatorKey,
      pageRouteBuilder(
        context,
        pageId,
        action.pageArgs?.map(
          (key, value) => MapEntry(
            key,
            value?.evaluate(scopeContext),
          ),
        ),
      ),
      removeRoutesUntilPredicate: routeNametoRemoveUntil.maybe(
        (p0) => removePreviousScreensInStack ? null : ModalRoute.withName(p0),
      ),
    );

    if (action.waitForResult && context.mounted) {
      await executeActionFlow(
        context,
        action.onResult ?? ActionFlow.empty(),
        DefaultScopeContext(variables: {
          'result': result,
        }, enclosing: scopeContext),
      );
    }

    return null;
  }
}
