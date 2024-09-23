import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../page/resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateToPageProcessor implements ActionProcessor<NavigateToPageAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ExprContext? exprContext,
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
    ExprContext? exprContext,
  ) async {
    final pageId = action.pageId;
    if (pageId == null) {
      throw ArgumentError('Null value', 'pageId');
    }

    final removePreviousScreensInStack =
        action.shouldRemovePreviousScreensInStack;
    final routeNametoRemoveUntil =
        action.routeNametoRemoveUntil?.evaluate(exprContext);

    final navigatorKey = ResourceProvider.maybeOf(context)?.navigatorKey;
    Object? result = await NavigatorHelper.push(
      context,
      navigatorKey,
      pageRouteBuilder(context, pageId, action.pageArgs),
      removeRoutesUntilPredicate: routeNametoRemoveUntil.maybe(
        (p0) => removePreviousScreensInStack ? null : ModalRoute.withName(p0),
      ),
    );

    if (action.waitForResult && context.mounted) {
      await executeActionFlow(
        context,
        action.onResult ?? ActionFlow.empty(),
        ExprContext(variables: {
          'result': result,
        }, enclosing: exprContext),
      );
    }

    return null;
  }
}
