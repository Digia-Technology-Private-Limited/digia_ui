import 'package:flutter/widgets.dart';

import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class DelayProcessor implements ActionProcessor<DelayAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    DelayAction action,
    ScopeContext? scopeContext,
  ) async {
    final durationInMs = action.durationInMs?.evaluate(scopeContext);

    if (durationInMs != null) {
      await Future.delayed(Duration(milliseconds: durationInMs));
    } else {
      // log('Wait Duration is null');
    }

    return null;
  }
}
