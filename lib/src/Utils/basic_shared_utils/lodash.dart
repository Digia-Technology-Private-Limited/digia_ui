import 'package:flutter/material.dart';

import '../extensions.dart';

Map<String, T> keyBy<T>(
  Iterable<T> list,
  String Function(T) keySelector,
) {
  return list.keyBy(keySelector);
}

extension LodashSetValue on Map<String, dynamic> {
  void _setValue(
      Map<String, dynamic> object, List<String> path, dynamic value) {
    final lastKey = path.removeLast();
    Map<String, dynamic> current = object;

    for (final key in path) {
      if (!current.containsKey(key) || current[key] is! Map<String, dynamic>) {
        current[key] = <String, dynamic>{};
      }
      current = current[key] as Map<String, dynamic>;
    }

    current[lastKey] = value;
  }

  void set(String path, dynamic value) {
    final pathParts = path.split('.');
    _setValue(this, pathParts, value);
  }
}

extension Lodash<T> on Iterable<T> {
  Map<String, T> keyBy(String Function(T) keySelector) {
    return fold({}, (result, element) {
      result[keySelector(element)] = element;
      return result;
    });
  }
}

// https://stackoverflow.com/a/66294173
extension MoveElement<T> on List<T> {
  void move(int from, int to) {
    RangeError.checkValidIndex(from, this, 'from', length);
    RangeError.checkValidIndex(to, this, 'to', length);
    var element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }

  void moveElement(T element, int offset) {
    var from = indexOf(element);
    if (from < 0) return; // Or throw, whatever you want.
    var to = from + offset;
    // Check to position is valid. Or cap it at 0/length - 1.
    RangeError.checkValidIndex(to, this, 'target position', length);
    element = this[from];
    if (from < to) {
      setRange(from, to, this, from + 1);
    } else {
      setRange(to + 1, from + 1, this, to);
    }
    this[to] = element;
  }
}

extension CastExt<T> on T? {
  /// Tries to cast this object to given type [R]. Returns null if the cast
  /// fails.
  R? tryCast<R>() {
    if (this == null) return null;
    try {
      return this as R;
    } catch (e) {
      // ignore: avoid_print
      debugPrint(
          'CastError when trying to cast $this to $T!. Error: ${e.toString()}');
      return null;
    }
  }

  R cast<R>() => this as R;
}

R? ifNotNull<R, T>(T? t, R? Function(T) fn) => (t == null) ? null : fn(t);

R? ifNotNull2<R, T0, T1>(T0? arg0, T1? arg1, R? Function(T0, T1) f) =>
    (arg0 != null && arg1 != null) ? f(arg0, arg1) : null;

extension Let<T> on T? {
  R? let<R>(R? Function(T) f) => ifNotNull(this, f);

  R? letIf<R>(bool Function(T) predicate, R? Function(T) f) {
    return this.let((p0) => predicate(p0) ? f(this as T) : null);
  }

  R? letIfTrue<R>(R? Function(T) block) {
    return this.letIf((p0) => !p0.isNullEmptyFalseOrZero, block);
  }
}

extension LetDynamic on dynamic {
  R? let<R>(R? Function(dynamic) fn) => ifNotNull(this, fn);
}

extension Let2<T, R> on (T?, R?) {
  S? let<S>(S Function(T, R) f) => ifNotNull2(this.$1, this.$2, f);
}
