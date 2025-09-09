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

    // Log state creation
    stateObserver?.onCreate(
      stateId,
      StateType.app,
      namespace: streamName.replaceAll('changeStream', ''),
      initialState: {'value': _value},
      metadata: {
        'streamName': streamName,
        'type': T.toString(),
      },
    );
  }

  /// Update the value and notify listeners
  /// Returns true if the value was actually changed
  bool update(T newValue) {
    if (_value != newValue) {
      final previousValue = _value;

      // Log state change
      stateObserver?.onChange(
        stateId,
        StateType.app,
        namespace: streamName.replaceAll('changeStream', ''),
        changes: {'value': newValue},
        previousState: {'value': previousValue},
        currentState: {'value': newValue},
        metadata: {
          'streamName': streamName,
          'type': T.toString(),
        },
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
      stateId,
      StateType.app,
      namespace: streamName.replaceAll('changeStream', ''),
      finalState: {'value': _value},
      metadata: {
        'streamName': streamName,
        'type': T.toString(),
      },
    );

    _controller.close();
  }
}
