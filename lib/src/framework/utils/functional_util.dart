import 'package:flutter/foundation.dart';

/// Provides a safe way to apply a function to a nullable value.
///
/// This extension method allows for chaining operations on nullable types,
/// similar to Optional in Java or Option in Scala.
///
/// Usage:
/// ```dart
/// final result = someNullableValue.maybe((v) => doSomething(v));
/// ```
///
/// [fn] is the function to apply if this value is not null.
/// Returns the result of [fn] if this is not null, otherwise returns null.
extension MaybeExt<T> on T? {
  R? maybe<R>(R? Function(T) fn) => this == null ? null : fn(this as T);
}

/// Provides a safe way to apply a function to two nullable values.
///
/// This extension method allows for combining two nullable values in a record
/// and applying a function to them only if both are non-null.
///
/// Usage:
/// ```dart
/// final result = (value1, value2).maybe((a, b) => combineValues(a, b));
/// ```
///
/// [fn] is the function to apply if both values in the record are not null.
/// Returns the result of [fn] if both values are not null, otherwise returns null.
extension MaybeTuple2<T, U> on (T?, U?) {
  R? maybe<R>(R Function(T, U) fn) =>
      $1 != null && $2 != null ? fn($1 as T, $2 as U) : null;
}

/// Attempts to cast a value to a specified type.
///
/// [x] The value to cast.
/// [orElse] An optional function to provide a default value if casting fails.
///
/// Returns the cast value, or throws if casting fails and no [orElse] is provided.
T as<T>(dynamic x, {T Function()? orElse}) {
  if (x is T) {
    return x;
  }
  if (orElse != null) {
    return orElse();
  }
  throw TypeError();
}

/// Safely attempts to cast a value to a specified type.
///
/// [x] The value to cast.
/// [orElse] An optional function to provide a default value if casting fails.
///
/// Returns the cast value, the result of [orElse] if provided, or null if casting fails.
T? as$<T>(dynamic x, {T? Function()? orElse}) {
  if (x is T) {
    return x;
  }
  // Consider using a logging framework instead of print for production code
  if (kDebugMode) {
    print('CastError when trying to cast $x to $T');
  }
  return orElse != null ? orElse() : null;
}
