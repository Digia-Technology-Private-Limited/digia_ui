import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class DelayProcessor extends ActionProcessor<DelayAction> {
  DelayProcessor({super.logger});

  @override
  Future<Object?>? execute(
    BuildContext context,
    DelayAction action,
    ScopeContext? scopeContext,
  ) async {
    final durationInMs = action.durationInMs?.evaluate(scopeContext);

    logger?.logAction(
      entitySlug: scopeContext!.name,
      actionType: action.actionType.value,
      actionData: {
        'durationInMs': durationInMs,
      },
    );

    if (durationInMs != null) {
      await Future<void>.delayed(Duration(milliseconds: durationInMs));
    } else {
      // log('Wait Duration is null');
    }

    return null;
  }
}
