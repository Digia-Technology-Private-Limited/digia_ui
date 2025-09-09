import 'package:flutter/widgets.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../action_descriptor.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateToPageProcessor extends ActionProcessor<NavigateToPageAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) executeActionFlow;

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
    ScopeContext? scopeContext, {
    required String eventId,
    required String parentId,
  }) async {
    final pageData = action.pageData?.deepEvaluate(scopeContext);
    final pageId = as$<String>(as$<JsonLike>(pageData)?['id']);
    if (pageId == null) {
      throw ArgumentError('Null value', 'id');
    }

    final evaluatedArgs = as$<JsonLike>(as$<JsonLike>(pageData)?['args']);

    final removePreviousScreensInStack =
        action.shouldRemovePreviousScreensInStack;
    final routeNametoRemoveUntil =
        action.routeNametoRemoveUntil?.evaluate(scopeContext);

    final desc = ActionDescriptor(
      id: eventId,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'id': pageId,
        'args': evaluatedArgs,
        'waitForResult': action.waitForResult,
        'shouldRemovePreviousScreensInStack': removePreviousScreensInStack,
        'routeNametoRemoveUntil': routeNametoRemoveUntil,
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
        'id': pageId,
        'args': evaluatedArgs,
        'waitForResult': action.waitForResult,
        'shouldRemovePreviousScreensInStack': removePreviousScreensInStack,
        'routeNametoRemoveUntil': routeNametoRemoveUntil,
      },
    );

    try {
      final navigatorKey = ResourceProvider.maybeOf(context)?.navigatorKey;

      final pushFuture = NavigatorHelper.push(
        context,
        navigatorKey,
        pageRouteBuilder(
          context,
          pageId,
          evaluatedArgs,
        ),
        removeRoutesUntilPredicate: routeNametoRemoveUntil.maybe(
          (p0) => removePreviousScreensInStack ? ModalRoute.withName(p0) : null,
        ),
      );

      executionContext?.notifyProgress(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        details: {
          'stage': 'page_pushed',
          'id': pageId,
          'navigatorKeyExists': navigatorKey != null,
        },
      );

      Object? result = await pushFuture;

      if (action.waitForResult && context.mounted) {
        await executeActionFlow(
          context,
          action.onResult ?? ActionFlow.empty(),
          DefaultScopeContext(variables: {
            'result': result,
          }, enclosing: scopeContext),
          eventId: eventId,
          parentId: parentId,
        );
      }

      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: null,
        stackTrace: null,
      );

      return null;
    } catch (error) {
      executionContext?.notifyComplete(
        eventId: eventId,
        parentId: parentId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
      );

      rethrow;
    }
  }
}
