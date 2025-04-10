import 'dart:async';

/// A reactive value that holds a value and exposes its changes
class ReactiveValue<T> {
  /// The current value
  T _value;

  /// Stream controller for value changes
  final _controller = StreamController<T>.broadcast();

  /// Stream of value changes
  StreamController<T> get controller => _controller;

  /// Get the current value
  T get value => _value;

  /// Create a new ReactiveValue with an initial value
  ReactiveValue(this._value);

  /// Update the value and notify listeners
  /// Returns true if the value was actually changed
  bool update(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      _controller.add(_value);
      return true;
    }
    return false;
  }

  /// Dispose the value and close the stream controller
  void dispose() {
    _controller.close();
  }
}
