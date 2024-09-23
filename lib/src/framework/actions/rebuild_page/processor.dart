import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../../base/state_context_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class RebuildPageProcessor implements ActionProcessor<RebuildPageAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    RebuildPageAction action,
    ExprContext? exprContext,
  ) {
    final originState = StateContextProvider.getOriginState(context);
    originState.triggerListeners();
    return null;
  }
}
