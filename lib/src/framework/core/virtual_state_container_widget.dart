import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../render_payload.dart';
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

    return StateContainer(
      nameSpace: refName,
      initialState: initialState,
      childBuilder: (context, state) {
        return child!.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(state),
          ),
        );
      },
    );
  }

  ExprContext _createExprContext(StateContext stateContext) {
    return ExprContext(
      variables: Map<String, Object?>.from(stateContext.stateVariables),
    );
  }
}

class StateContext extends ChangeNotifier {
  final String? nameSpace;
  final Map<String, Object?> stateVariables;
  final StateContext? _enclosing;

  StateContext(
    this.nameSpace, {
    required this.stateVariables,
    StateContext? enclosing,
  }) : _enclosing = enclosing;

  Object? get(String key) {
    if (stateVariables.containsKey(key)) {
      return stateVariables[key];
    }
    return _enclosing?.get(key);
  }

  // Useful for accessing state from child containers
  StateContext? findAncestorContextOf(String name) {
    if (nameSpace == name) return this;

    return _enclosing?.findAncestorContextOf(name);
  }

  void set(String key, Object? value, {bool notify = true}) {
    if (stateVariables.containsKey(key)) {
      stateVariables[key] = value;
      if (notify) notifyListeners();
    }

    // Code shouldn't reach here.
  }
}

class StateContainer extends StatefulWidget {
  final String? nameSpace;
  final Widget Function(BuildContext context, StateContext state) childBuilder;
  final Map<String, Object?> initialState;

  const StateContainer({
    super.key,
    required this.childBuilder,
    required this.initialState,
    required this.nameSpace,
  });

  @override
  State<StateContainer> createState() => _StateContainerState();
}

class _StateContainerState extends State<StateContainer> {
  late StateContext _stateContext;

  @override
  void initState() {
    super.initState();
    final ancestorScope = StateScope.maybeOf(context);
    _stateContext = StateContext(
      widget.nameSpace,
      stateVariables: widget.initialState,
      enclosing: ancestorScope?.stateContext,
    );
  }

  @override
  void dispose() {
    _stateContext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StateScope(
      stateContext: _stateContext,
      child: ListenableBuilder(
        listenable: _stateContext,
        builder: (context, _) => widget.childBuilder(context, _stateContext),
      ),
    );
  }
}

// This may not be used for reading the state variables. ExprContext solves for it.
// But we use InheritedWidget to be able to call setState on any StateContext
// anywhere down in the heirarchy.
class StateScope extends InheritedWidget {
  final StateContext stateContext;

  const StateScope({
    super.key,
    required this.stateContext,
    required super.child,
  });

  static StateScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StateScope>();
  }

  static StateScope of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No StateScope found in context');
    return result!;
  }

  static StateContext? findState(BuildContext context, String? nameSpace) {
    final scope = StateScope.maybeOf(context);

    if (nameSpace == null) return scope?.stateContext;

    return scope?.stateContext.findAncestorContextOf(nameSpace);
  }

  // We don't need to notify on updates because the state changes are handled
  // by the ListenableBuilder in the StateContainer.
  @override
  bool updateShouldNotify(StateScope oldWidget) => false;
}
