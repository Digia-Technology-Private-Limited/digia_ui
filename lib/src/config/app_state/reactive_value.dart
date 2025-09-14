import 'dart:async';
import 'package:digia_inspector_core/digia_inspector_core.dart';

import '../../init/digia_ui_manager.dart';

/// A reactive value that holds a value and exposes its changes
class ReactiveValue<T> {
  /// The current value
  T _value;

  ///Stream Key Name
  final String streamName;

  /// Unique ID for this reactive value instance
  late final String stateId;

  /// Derived namespace (stream name without `changeStream`)
  late final String namespace;

  /// Static state observer for logging app state changes
  static StateObserver? get stateObserver =>
      DigiaUIManager().inspector?.stateObserver;

  /// Stream controller for value changes
  final _controller = StreamController<T>.broadcast();

  /// Stream of value changes
  StreamController<T> get controller => _controller;

  /// Get the current value
  T get value => _value;

  /// Create a new ReactiveValue with an initial value
  ReactiveValue(this._value, this.streamName) {
    stateId = TimestampHelper.generateId();
    namespace = streamName.replaceAll('changeStream', '');

    // Log state creation
    stateObserver?.onCreate(
      id: stateId,
      stateType: StateType.app,
      namespace: namespace,
      stateData: {'value': _value},
    );
  }

  /// Update the value and notify listeners
  /// Returns true if the value was actually changed
  bool update(T newValue) {
    if (_value != newValue) {
      // Log state change
      stateObserver?.onChange(
        id: stateId,
        stateType: StateType.app,
        namespace: namespace,
        stateData: {'value': newValue},
      );

      _value = newValue;
      _controller.add(_value);
      return true;
    }
    return false;
  }

  /// Dispose the value and close the stream controller
  void dispose() {
    // Log state disposal
    stateObserver?.onDispose(
      id: stateId,
      stateType: StateType.app,
      namespace: namespace,
      stateData: {'value': _value},
    );

    _controller.close();
  }
}
