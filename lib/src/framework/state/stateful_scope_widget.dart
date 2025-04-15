import 'package:flutter/widgets.dart';
import 'state_context.dart';
import 'state_context_provider.dart';

/// A widget that manages a scoped [StateContext] and rebuilds its child when the state changes.
/// It forms part of a hierarchical state management system.
class StatefulScopeWidget extends StatefulWidget {
  /// The namespace for this state scope.
  final String? namespace;

  /// A function that builds the child widget using the current state.
  final Widget Function(BuildContext context, StateContext state) childBuilder;

  /// The initial state values for this scope.
  final Map<String, Object?> initialState;

  const StatefulScopeWidget({
    super.key,
    required this.childBuilder,
    required this.initialState,
    this.namespace,
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
      initialState: widget.initialState,
      ancestorContext: ancestorProvider?.stateContext,
    );
  }

  @override
  void didUpdateWidget(StatefulScopeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.namespace != oldWidget.namespace) {
    // If the namespace changes, we need to reinitialize the state context
    _initializeStateContext();
    // }
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
