import 'package:flutter/foundation.dart';

class AsyncController<T> extends ChangeNotifier {
  Future<T> Function()? _futureBuilder;

  bool _isDirty = false;
  Future<T>? _currentFuture;

  AsyncController({Future<T> Function()? futureBuilder}) {
    _futureBuilder = futureBuilder;
    _currentFuture = _futureBuilder?.call();
  }

  // Ideally we should be invalidating when futureBuilder is set,
  // but we can't for now.
  void setFutureBuilder(Future<T> Function() futureBuilder) {
    _futureBuilder = futureBuilder;
    // if (refresh) {
    //   invalidateAndNotify();
    // } else {
    //   invalidate();
    // }
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
      _currentFuture = _futureBuilder?.call();
      _isDirty = false;
      return _currentFuture;
    }

    return _currentFuture;
  }
}
