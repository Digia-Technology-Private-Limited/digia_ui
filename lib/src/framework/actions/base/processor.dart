import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import 'action.dart' as an;

abstract class ActionProcessor<T extends an.Action> {
  Future<Object?>? execute(
    BuildContext context,
    T action,
    ScopeContext? scopeContext,
  );
}
