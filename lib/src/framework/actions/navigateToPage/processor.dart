import 'package:flutter/widgets.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../models/types.dart';
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
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateToPageAction action,
    ScopeContext? scopeContext,
  ) async {
    final pageId = as$<String>(as$<JsonLike>(action.pageData)?['pageId']);
    if (pageId == null) {
      throw ArgumentError('Null value', 'pageId');
    }

    final removePreviousScreensInStack =
        action.shouldRemovePreviousScreensInStack;
    final routeNametoRemoveUntil =
        action.routeNametoRemoveUntil?.evaluate(scopeContext);

    logAction(
      action.actionType.value,
      {
        'pageId': pageId,
        'pageArgs': as$<JsonLike>(action.pageData)?['pageArgs'],
        'waitForResult': action.waitForResult,
        'shouldRemovePreviousScreensInStack': removePreviousScreensInStack,
        'routeNametoRemoveUntil': routeNametoRemoveUntil,
        'onResult': action.onResult?.actions
            .map((a) => a.actionType.value)
            .toList()
            .toString(),
      },
    );

    final navigatorKey = ResourceProvider.maybeOf(context)?.navigatorKey;
    Object? result = await NavigatorHelper.push(
      context,
      navigatorKey,
      pageRouteBuilder(
        context,
        pageId,
        as$<JsonLike>(as$<JsonLike>(action.pageData)?['pageArgs'])?.map(
          (key, value) => MapEntry(
            key,
            ExprOr.fromJson<Object>(value),
          ),
        ),
      ),
      removeRoutesUntilPredicate: routeNametoRemoveUntil.maybe(
        (p0) => removePreviousScreensInStack ? ModalRoute.withName(p0) : null,
      ),
    );

    if (action.waitForResult && context.mounted) {
      logAction(
        '${action.actionType.value} - Result',
        {
          'pageId': pageId,
          'result': result,
        },
      );
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
