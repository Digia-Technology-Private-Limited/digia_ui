import 'dart:async';

import 'package:digia_expr/digia_expr.dart';

class TimerController implements ExprInstance {
  final int initialValue;
  final Duration updateInterval;
  final bool isCountDown;
  final int duration;

  final StreamController<int> _controller;
  StreamSubscription<int>? _subscription;
  int _currentValue;

  TimerController({
    required this.initialValue,
    required this.updateInterval,
    required this.isCountDown,
    required this.duration,
  })  : _currentValue = initialValue,
        _controller = StreamController<int>.broadcast();

  bool _isRunning = false;

  Stream<int> get stream => _controller.stream;

  // Expose the current tick value
  int get currentValue => _currentValue;

  void start() {
    if (_isRunning) return;
    _isRunning = true;

    final periodicStream = Stream<int>.periodic(updateInterval, (count) {
      if (isCountDown) {
        return initialValue - count;
      } else {
        return initialValue + count;
      }
    }).take(duration + 1); // +1 to include the initial value

    _subscription = periodicStream.listen(
      (value) {
        _currentValue = value;
        _controller.add(value);
      },
      onDone: () {
        _isRunning = false;
        _controller.close();
      },
    );
  }

  void reset() {
    _subscription?.cancel();
    _currentValue = initialValue;
    _isRunning = false;
    start();
  }

  void pause() {
    _subscription?.pause();
  }

  void resume() {
    _subscription?.resume();
  }

  void dispose() {
    if (!_controller.hasListener) {
      _subscription?.cancel();
      _isRunning = false;
      _controller.close();
    }
  }

  @override
  Object? getField(String name) => switch (name) {
        'currentValue' => currentValue,
        _ => null,
      };
}
