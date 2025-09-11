import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../base/virtual_widget.dart';
import '../data_type/data_type_creator.dart';
import '../data_type/variable.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import 'state_context.dart';
import 'state_scope_context.dart';
import 'stateful_scope_widget.dart';

class VirtualStateContainerWidget extends VirtualWidget {
  final Map<String, Variable> initStateDefs;
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

    final resolvedState = initStateDefs.map((k, v) => MapEntry(
        k,
        DataTypeCreator.create(
          v,
          scopeContext: payload.scopeContext,
        )));

    // Build hierarchy context for state container
    final hierarchyContext = buildHierarchyContext(payload);

    return StatefulScopeWidget(
      namespace: refName,
      initialState: resolvedState,
      stateType: StateType.stateContainer,
      childBuilder: (context, state) {
        final updatedPayload = payload.copyWithChainedContext(
          _createExprContext(state),
          buildContext: context,
          observabilityContext: hierarchyContext,
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
