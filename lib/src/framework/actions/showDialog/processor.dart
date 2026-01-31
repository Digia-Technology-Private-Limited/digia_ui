import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';

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

class ShowDialogProcessor extends ActionProcessor<ShowDialogAction> {
  final Widget Function(BuildContext context, String id, JsonLike? args)
      viewBuilder;
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) executeActionFlow;

  ShowDialogProcessor({
    required this.viewBuilder,
    required this.executeActionFlow,
    super.executionContext,
  });

  @override
  Future<Object?>? execute(
      BuildContext context, ShowDialogAction action, ScopeContext? scopeContext,
      {required String id,
      String? parentActionId,
      ObservabilityContext? observabilityContext}) async {
    final provider = ResourceProvider.maybeOf(context);

    final barrierDismissible =
        action.barrierDismissible?.evaluate(scopeContext) ?? true;
    final barrierColor = action.barrierColor
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0, context));
    final waitForResult = action.waitForResult;

    final viewData = action.viewData?.deepEvaluate(scopeContext);
    final evaluatedArgs = as$<JsonLike>(as$<JsonLike>(viewData)?['args']);
    final dialogId = as$<String>(as$<JsonLike>(viewData)?['id']);

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'id': dialogId,
        'args': evaluatedArgs,
        'barrierDismissible': barrierDismissible,
        'waitForResult': waitForResult,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    executionContext?.notifyProgress(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      details: {
        'id': dialogId,
        'args': evaluatedArgs,
        'barrierDismissible': barrierDismissible,
        'waitForResult': waitForResult,
      },
      observabilityContext: observabilityContext,
    );

    try {
      final future = presentDialog(
        context: context,
        builder: (innerCtx) {
          return viewBuilder(
            innerCtx,
            dialogId ?? '',
            evaluatedArgs,
          );
        },
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
      );

      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stage': 'dialog_presented',
          'id': dialogId,
          'success': true,
        },
        observabilityContext: observabilityContext,
      );

      Object? result = await future;

      if (waitForResult && context.mounted) {
        final onResultContext =
            observabilityContext?.forTrigger(triggerType: 'onResult');

        await executeActionFlow(
          context,
          action.onResult ?? ActionFlow.empty(),
          DefaultScopeContext(variables: {
            'result': result,
          }, enclosing: scopeContext),
          id: id,
          parentActionId: parentActionId,
          observabilityContext: onResultContext,
        );
      }

      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: null,
        stackTrace: null,
        observabilityContext: observabilityContext,
      );

      return null;
    } catch (error) {
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      rethrow;
    }
  }
}
