import 'dart:async';

class Debouncer {
  /// The delay duration before the action is executed.
  final Duration delay;

  /// Internal timer to manage debounce behavior.
  Timer? _timer;

  /// Creates a Debouncer with the specified delay.
  ///
  /// The [delay] defaults to 5 seconds if not provided.
  Debouncer({required this.delay});

  /// Schedules the given [action] to be executed after the delay.
  ///
  /// If called again before the delay expires, the previous action is cancelled
  /// and a new one is scheduled.
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
  }
}
