import 'package:flutter/widgets.dart';

import '../../../dui_logger.dart';
import '../../expr/scope_context.dart';
import 'action.dart' as an;

abstract class ActionProcessor<T extends an.Action> {
  DUILogger? logger;

  ActionProcessor({this.logger});

  Future<Object?>? execute(
    BuildContext context,
    T action,
    ScopeContext? scopeContext,
  );
}
