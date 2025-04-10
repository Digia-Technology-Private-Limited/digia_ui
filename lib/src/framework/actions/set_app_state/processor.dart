import 'package:flutter/widgets.dart';

import '../../../config/app_state/global_state.dart';
import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class ControlSetAppStateProcessor
    extends ActionProcessor<ControlSetAppStateAction> {
  ControlSetAppStateProcessor();

  @override
  Future<Object?>? execute(
    BuildContext context,
    ControlSetAppStateAction action,
    ScopeContext? scopeContext,
  ) {
    final object = action.value?.evaluate(scopeContext);

    logAction(
      action.actionType.value,
      {
        'name': action.name,
        'value': object,
      },
    );
    GlobalState().update(action.name, object);
    return null;
  }
}
