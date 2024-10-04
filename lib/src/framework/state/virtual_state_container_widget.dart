import 'package:flutter/widgets.dart';

import '../../models/variable_def.dart';
import '../base/virtual_widget.dart';
import '../expr/expression_util.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import 'state_context.dart';
import 'state_scope_context.dart';
import 'stateful_scope_widget.dart';

class VirtualStateContainerWidget extends VirtualWidget {
  final Map<String, VariableDef?> initStateDefs;
  VirtualWidget? child;

  VirtualStateContainerWidget({
    required super.refName,
    required super.parent,
    required this.initStateDefs,
    Map<String, List<VirtualWidget>>? childGroups,
  }) : child = childGroups?.entries.firstOrNull?.value.firstOrNull;

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final resolvedState = initStateDefs.map((key, value) => MapEntry(
        key,
        evaluateNestedExpressions(
          value?.defaultValue,
          payload.scopeContext,
        )));

    return StatefulScopeWidget(
      namespace: refName,
      initialState: resolvedState,
      childBuilder: (context, state) {
        final updatedPayload = payload.copyWithChainedContext(
          _createExprContext(state),
          buildContext: context,
        );
        return child!.toWidget(updatedPayload);
      },
    );
  }

  ScopeContext _createExprContext(StateContext stateContext) {
    return StateScopeContext(
      stateContext: stateContext,
    );
  }
}
