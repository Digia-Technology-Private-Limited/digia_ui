import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../base/state_context_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class SetStateProcessor implements ActionProcessor<SetStateAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    SetStateAction action,
    ExprContext? exprContext,
  ) async {
    final stateContext =
        StateContextProvider.findStateByName(context, action.stateContextName);
    if (stateContext == null) {
      throw 'Action.setPageState called on a widget which is not wrapped in StateContextProvider';
    }

    final updates = action.updates;
    final rebuildPage = action.rebuild?.evaluate(exprContext) ?? true;

    if (updates.isNotEmpty) {
      final updatesMap = Map.fromEntries(
          updates.map((update) => MapEntry(update.stateName, update.newValue)));
      stateContext.setValues(updatesMap, notify: rebuildPage);
    }

    return null;
  }
}
