import 'package:flutter/material.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowDialogProcessor extends ActionProcessor<ShowDialogAction> {
  final Widget Function(BuildContext context, String id, JsonLike? args)
      viewBuilder;
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  ShowDialogProcessor({
    required this.viewBuilder,
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowDialogAction action,
    ScopeContext? scopeContext,
  ) async {
    final provider = ResourceProvider.maybeOf(context);

    final barrierDismissible =
        action.barrierDismissible?.evaluate(scopeContext) ?? true;
    final barrierColor = action.barrierColor
        ?.evaluate(scopeContext)
        .maybe((p0) => provider?.getColor(p0));
    final waitForResult = action.waitForResult;

    logAction(
      action.actionType.value,
      {
        'viewId': action.viewId,
        'args': action.args,
        'barrierDismissible': barrierDismissible,
        'barrierColor': barrierColor.toString(),
        'waitForResult': waitForResult,
        'onResult': action.onResult?.actions
            .map((a) => a.actionType.value)
            .toList()
            .toString(),
      },
    );

    Object? result = await presentDialog(
      context: context,
      builder: (innerCtx) {
        return viewBuilder(
          innerCtx,
          action.viewId,
          action.args?.map((key, value) => MapEntry(
                key,
                value?.evaluate(scopeContext),
              )),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );

    if (waitForResult && context.mounted) {
      logAction(
        '${action.actionType.value} - Result',
        {
          'viewId': action.viewId,
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
