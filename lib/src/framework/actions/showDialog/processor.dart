import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../models/types.dart';
import '../../page/resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/navigation_util.dart';
import '../../utils/types.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class ShowDialogProcessor implements ActionProcessor<ShowDialogAction> {
  final Widget Function(BuildContext context, String id, JsonLike? args)
      viewBuilder;
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ExprContext? exprContext,
  ) executeActionFlow;

  ShowDialogProcessor({
    required this.viewBuilder,
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    ShowDialogAction action,
    ExprContext? exprContext,
  ) async {
    final provider = ResourceProvider.maybeOf(context);

    final barrierDismissible =
        action.barrierDismissible?.evaluate(exprContext) ?? true;
    final barrierColor = action.barrierColor
        ?.evaluate(exprContext)
        .maybe((p0) => provider?.getColor(p0));
    final waitForResult = action.waitForResult;

    Object? result = await presentDialog(
      context: context,
      builder: (innerCtx) {
        return viewBuilder(
          innerCtx,
          action.pageId,
          action.pageArgs?.map((key, value) {
            var evaluatedValue = value;
            if (value is ExprOr) {
              evaluatedValue = value.evaluate(exprContext);
            }
            return MapEntry(key, evaluatedValue);
          }),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
    );

    if (waitForResult && context.mounted) {
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
