import 'package:flutter/widgets.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../../utils/network_util.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class CallRestApiProcessor extends ActionProcessor<CallRestApiAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  CallRestApiProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    CallRestApiAction action,
    ScopeContext? scopeContext,
  ) async {
    final apiModel = ResourceProvider.maybeOf(context)?.apiModels[action.apiId];

    if (apiModel == null) {
      return Future.error('No API Selected');
    }

    logAction(
      action.actionType.value,
      {
        'apiId': action.apiId,
        'args': action.args,
      },
    );

    return executeApiAction(
      scopeContext,
      apiModel,
      action.args,
      successCondition: action.successCondition,
      onSuccess: (response) async {
        if (action.onSuccess != null) {
          await executeActionFlow(
              context,
              action.onSuccess!,
              DefaultScopeContext(
                variables: {'response': response},
                enclosing: scopeContext,
              ));
        }
      },
      onError: (response) async {
        if (action.onError != null) {
          await executeActionFlow(
              context,
              action.onError!,
              DefaultScopeContext(
                variables: {'response': response},
                enclosing: scopeContext,
              ));
        }
      },
    );
  }
}
