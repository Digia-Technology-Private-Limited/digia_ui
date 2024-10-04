import 'package:flutter/widgets.dart';

import 'state_context.dart';

/// Provides access to a [StateContext] throughout the widget tree.
///
/// This InheritedWidget is used primarily for accessing the [StateContext]
/// to call setState, rather than for reading state variables directly.
class StateContextProvider extends InheritedWidget {
  /// The [StateContext] being provided down the widget tree.
  final StateContext stateContext;

  const StateContextProvider({
    super.key,
    required this.stateContext,
    required super.child,
  });

  /// Retrieves the nearest [StateContextProvider] instance from the given context,
  /// without creating a dependency.
  static StateContextProvider? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<StateContextProvider>();
  }

  /// Retrieves the nearest [StateContextProvider] instance from the given context.
  ///
  /// Throws an assertion error if no [StateContextProvider] is found.
  static StateContextProvider of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No StateContextProvider found in context');
    return result!;
  }

  /// Finds the Immediate [StateContext] in the widget tree.
  static StateContext? getImmediateState(BuildContext context) {
    final scope = maybeOf(context);
    return scope?.stateContext;
  }

  /// Finds a [StateContext] with the specified namespace.
  ///
  /// Returns null if no matching namespace is found.
  static StateContext? findStateByName(BuildContext context, String namespace) {
    final scope = maybeOf(context);
    if (scope == null) return null;

    return scope.stateContext.findAncestorContext(namespace);
  }

  /// Finds the origin [StateContext] (the topmost context in the hierarchy).
  static StateContext getOriginState(BuildContext context) {
    final scope = of(context);
    return scope.stateContext.originContext;
  }

  /// We don't need to notify on updates because:
  /// 1. We're not using dependOnInheritedWidgetOfExactType, so no widgets depend on this for rebuilds.
  /// 2. State changes are handled by the ListenableBuilder in the StateContainer.
  @override
  bool updateShouldNotify(StateContextProvider oldWidget) => false;
}
