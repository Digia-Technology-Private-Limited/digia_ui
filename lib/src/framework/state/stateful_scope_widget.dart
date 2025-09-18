import 'package:digia_inspector_core/digia_inspector_core.dart' show StateType;
import 'package:flutter/widgets.dart';

import 'state_context.dart';
import 'state_context_provider.dart';

/// A widget that manages a scoped [StateContext] and rebuilds its child when the state changes.
/// It forms part of a hierarchical state management system.
class StatefulScopeWidget extends StatefulWidget {
  /// The namespace for this state scope.
  final String? namespace;

  /// The ID of this state scope.
  final String stateId;

  /// A function that builds the child widget using the current state.
  final Widget Function(BuildContext context, StateContext state) childBuilder;

  /// The initial state values for this scope.
  final Map<String, Object?> initialState;

  /// The type of state this widget manages.
  final StateType stateType;

  const StatefulScopeWidget({
    super.key,
    required this.stateId,
    required this.childBuilder,
    required this.initialState,
    this.namespace,
    this.stateType = StateType.stateContainer,
  });

  @override
  State<StatefulScopeWidget> createState() => _StatefulScopeWidgetState();
}

class _StatefulScopeWidgetState extends State<StatefulScopeWidget> {
  late StateContext _stateContext;

  @override
  void initState() {
    super.initState();
    _initializeStateContext();
  }

  void _initializeStateContext() {
    final ancestorProvider = StateContextProvider.maybeOf(context);
    _stateContext = StateContext(
      widget.namespace,
      stateId: widget.stateId,
      initialState: widget.initialState,
      ancestorContext: ancestorProvider?.stateContext,
      stateType: widget.stateType,
    );
  }

  @override
  void didUpdateWidget(StatefulScopeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO: Optimize widget updates by implementing state diffing to only re-initialize
    // when necessary, rather than on every didUpdateWidget call

    // Currently, we re-initialize the state context on every widget update.
    // Ideally, we would only re-initialize when oldWidget.initialState differs from widget.initialState,
    // but implementing efficient state diffing is complex and not yet implemented.
    _initializeStateContext();
  }

  @override
  void dispose() {
    _stateContext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateContextProvider(
      stateContext: _stateContext,
      child: ListenableBuilder(
        listenable: _stateContext,
        builder: (context, _) => widget.childBuilder(context, _stateContext),
      ),
    );
  }
}
