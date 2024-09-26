import 'dart:async';

class TimerController {
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
        _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream;

  // Expose the current tick value
  int get currentValue => _currentValue;

  void start() {
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
        _controller.close();
      },
    );
  }

  void pause() {
    _subscription?.pause();
  }

  void resume() {
    _subscription?.resume();
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
