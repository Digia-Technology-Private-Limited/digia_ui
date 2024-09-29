import 'package:flutter/widgets.dart';

import '../expr/scope_context.dart';
import '../render_payload.dart';
import 'state_context.dart';
import 'state_scope_context.dart';
import 'stateful_scope_widget.dart';
import 'virtual_widget.dart';

class VirtualStateContainerWidget extends VirtualWidget {
  final Map<String, Object?> initialState;
  final VirtualWidget? child;

  VirtualStateContainerWidget({
    required super.refName,
    required super.parent,
    required this.initialState,
    required this.child,
  });

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    return StatefulScopeWidget(
      namespace: refName,
      initialState: initialState,
      childBuilder: (context, state) {
        return child!.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(state),
            buildContext: context,
          ),
        );
      },
    );
  }

  ScopeContext _createExprContext(StateContext stateContext) {
    return StateScopeContext(
      stateContext: stateContext,
    );
  }
}
