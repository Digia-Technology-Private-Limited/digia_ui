import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class NavigateBackProcessor extends ActionProcessor<NavigateBackAction> {
  NavigateBackProcessor({super.logger});

  @override
  Future<Object?>? execute(
    BuildContext context,
    NavigateBackAction action,
    ScopeContext? scopeContext,
  ) async {
    final maybe = action.maybe?.evaluate(scopeContext) ?? false;
    final result = {
      'data': action.result?.deepEvaluate(scopeContext),
    };

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'maybe': maybe,
        'result': result,
      },
    );

    if (maybe) {
      return Navigator.of(context).maybePop(result);
    } else {
      Navigator.of(context).pop(result);
      return null;
    }
  }
}
