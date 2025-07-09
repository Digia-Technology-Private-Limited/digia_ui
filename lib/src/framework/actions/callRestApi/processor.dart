import 'package:flutter/widgets.dart';

import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../models/types.dart';
import '../../resource_provider.dart';
import '../../utils/functional_util.dart';
import '../../utils/network_util.dart';
import '../../utils/types.dart';
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
    final dataSource = action.dataSource?.evaluate(scopeContext);
    final apiModel = ResourceProvider.maybeOf(context)
        ?.apiModels[as$<JsonLike>(dataSource)?['id']];

    if (apiModel == null) {
      return Future.error('No API Selected');
    }

    logAction(
      action.actionType.value,
      {
        'dataSource': action.dataSource?.toJson(),
      },
    );

    return executeApiAction(
      scopeContext,
      apiModel,
      as$<JsonLike>(as$<JsonLike>(dataSource)?['args'])
          ?.map((key, value) => MapEntry(
                key,
                ExprOr.fromJson<Object>(value),
              )),
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
