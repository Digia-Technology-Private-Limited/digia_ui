import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../../state/state_context_provider.dart';
import '../base/processor.dart';
import 'action.dart';

class RebuildPageProcessor implements ActionProcessor<RebuildPageAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    RebuildPageAction action,
    ScopeContext? scopeContext,
  ) {
    final originState = StateContextProvider.getOriginState(context);
    originState.triggerListeners();
    return null;
  }
}
