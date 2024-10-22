import 'package:flutter/foundation.dart';

class AsyncController<T> extends ChangeNotifier {
  Future<T> Function()? _futureCreator;

  bool _isDirty = true;
  Future<T>? _currentFuture;

  AsyncController({Future<T> Function()? futureCreator}) {
    _futureCreator = futureCreator;
    _currentFuture = _futureCreator?.call();
  }

  // Ideally we should be invalidating when futureBuilder is set,
  // but we can't for now.
  void setFutureCreator(Future<T> Function() futureCreator) {
    _futureCreator = futureCreator;
  }

  /// Invalidates the current future and creates a new one
  void invalidate() {
    _isDirty = true;
    _currentFuture = null;
  }

  /// Invalidates the current future, creates a new one, and notifies listeners
  void invalidateAndNotify() {
    invalidate();
    notifyListeners();
  }

  Future<T>? getFuture() {
    if (_isDirty) {
      _currentFuture = _futureCreator?.call();
      _isDirty = false;
      return _currentFuture;
    }

    return _currentFuture;
  }
}
