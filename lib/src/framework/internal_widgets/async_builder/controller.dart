import 'package:flutter/foundation.dart';

class AsyncController<T> extends ChangeNotifier {
  Future<T> Function()? _futureBuilder;
  Future<T>? _currentFuture;

  AsyncController({Future<T> Function()? futureBuilder}) {
    _futureBuilder = futureBuilder;
    _currentFuture = _futureBuilder?.call();
  }

  void setFutureBuilder(Future<T> Function() futureBuilder,
      {bool refresh = false}) {
    _futureBuilder = futureBuilder;
    if (refresh) {
      invalidateAndNotify();
    } else {
      invalidate();
    }
  }

  /// Invalidates the current future and creates a new one
  void invalidate() {
    _currentFuture = _futureBuilder?.call();
  }

  /// Invalidates the current future, creates a new one, and notifies listeners
  void invalidateAndNotify() {
    invalidate();
    notifyListeners();
  }

  Future<T>? get future => _currentFuture;
}
