import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../../init/digia_ui_manager.dart';

/// Manages state for a specific namespace and provides access to enclosing contexts.
class StateContext extends ChangeNotifier {
  /// The state observer, if any.
  static StateObserver? get stateObserver =>
      DigiaUIManager().inspector?.stateObserver;

  /// The unique identifier for this state context.
  final String? namespace;

  /// Unique ID for this state context instance.
  final String stateId;

  /// The type of state this context represents.
  late final StateType _stateType;

  /// The state variables stored in this context.
  final Map<String, Object?> _stateVariables;

  /// The parent context, if any.
  final StateContext? _ancestorContext;

  StateContext(
    this.namespace, {
    required this.stateId,
    required Map<String, Object?> initialState,
    StateContext? ancestorContext,
    StateType stateType = StateType.stateContainer,
  })  : _stateVariables = Map.from(initialState),
        _ancestorContext = ancestorContext {
    // Generate unique state ID
    _stateType = stateType;

    // Log state creation
    stateObserver?.onCreate(
      id: stateId,
      stateType: stateType,
      namespace: namespace,
      stateData: Map.from(initialState),
    );
  }

  @override
  void dispose() {
    stateObserver?.onDispose(
      id: stateId,
      stateType: _stateType,
      namespace: namespace,
      stateData: Map.from(_stateVariables),
    );
    super.dispose();
  }

  /// Traverses the StateContext hierarchy to find the Origin context.
  ///
  /// This context typically belongs to the root Page or Component.
  /// It's useful for accessing global state or performing actions
  /// that affect the entire state tree.
  StateContext get originContext {
    StateContext current = this;
    while (current._ancestorContext != null) {
      current = current._ancestorContext;
    }
    return current;
  }

  /// Retrieves a value from the state, searching up the context hierarchy if necessary.
  Object? getValue(String key) {
    if (_stateVariables.containsKey(key)) {
      return _stateVariables[key];
    }
    return _ancestorContext?.getValue(key);
  }

  /// Finds an ancestor context with the specified namespace.
  StateContext? findAncestorContext(String targetNamespace) {
    if (namespace == targetNamespace) return this;
    return _ancestorContext?.findAncestorContext(targetNamespace);
  }

  /// Updates a value in the state, notifying listeners if specified.
  ///
  /// Returns true if the update was successful, false otherwise.
  bool setValue(String key, Object? value, {bool notify = true}) {
    if (_stateVariables.containsKey(key)) {
      _stateVariables[key] = value;

      if (namespace != null) {
        stateObserver?.onChange(
          id: stateId,
          stateType: _stateType,
          namespace: namespace,
          stateData: Map<String, Object?>.from(_stateVariables),
        );
      }
      if (notify) notifyListeners();
      return true;
    }
    return false;
  }

  /// Updates multiple values in the state, notifying listeners once if specified.
  ///
  /// Returns a map of keys to boolean values indicating whether each update was successful.
  Map<String, bool> setValues(Map<String, Object?> updates,
      {bool notify = true}) {
    Map<String, bool> results = {};
    bool anyUpdated = false;

    final nextState = Map<String, Object?>.from(_stateVariables);

    updates.forEach((key, value) {
      if (hasKey(key)) {
        nextState[key] = value;
        _stateVariables[key] = value;
        results[key] = true;
        anyUpdated = true;
      } else {
        results[key] = false;
      }
    });

    if (notify && anyUpdated) {
      if (namespace != null) {
        stateObserver?.onChange(
          id: stateId,
          stateType: _stateType,
          namespace: namespace,
          stateData: Map<String, Object?>.from(_stateVariables),
        );
      }
      notifyListeners();
    }

    return results;
  }

  /// Notifies all listeners that the state has changed, triggering a rebuild.
  void triggerListeners() {
    notifyListeners();
  }

  /// Checks if a key exists in the current context (not including parent contexts).
  bool hasKey(String key) => _stateVariables.containsKey(key);

  /// Returns a read-only view of the state variables.
  Map<String, Object?> get stateVariables => Map.unmodifiable(_stateVariables);
}
