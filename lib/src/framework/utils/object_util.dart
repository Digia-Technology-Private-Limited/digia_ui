import 'package:flutter/foundation.dart';

import 'num_util.dart';

/// Extension on Object? to provide a flexible type conversion method.
extension ObjectExt on Object? {
  /// Attempts to convert the object to type R.
  ///
  /// This method provides a flexible way to convert objects to various types,
  /// with built-in support for String, int, double, and bool conversions.
  ///
  /// [R] The type to convert to.
  /// [defaultValue] An optional default value to return if conversion fails.
  ///
  /// Returns:
  /// - The converted value of type R if successful.
  /// - The [defaultValue] if provided and conversion fails.
  /// - null if conversion fails and no [defaultValue] is provided.
  R? to<R>({R? defaultValue}) {
    final value = this;
    // If the value is null, return the default value
    if (value == null) return defaultValue;

    // If the value is already of type R, return it
    if (value is R) return value as R?;

    // Attempt type-specific conversions
    return switch (R) {
          // Convert to String using toString()
          const (String) => value.toString() as R?,
          // Use NumUtil for numeric conversions
          const (int) => NumUtil.toInt(value) as R?,
          const (double) => NumUtil.toDouble(value) as R?,
          // Use NumUtil for boolean conversion
          const (bool) => NumUtil.toBool(value) as R?,
          // For any other type, attempt a safe cast
          _ => value.as$<R>()
        } ??
        // If all conversions fail, return the default value
        defaultValue;
  }

  /// Safely attempts to cast the current object to a specified type R, with graceful fallback to null.
  ///
  /// This method differs significantly from Dart's `as` operator:
  /// - It returns `null` instead of throwing an exception if the cast fails.
  /// - It provides debug logging for failed casts in debug mode.
  ///
  /// Key differences from Dart's `as`:
  /// 1. `obj.as$<T>()` returns `null` if `obj` is not of type `T`.
  /// 2. `obj as T?` throws an exception if `obj` is not `null` and not of type `T`.
  ///
  /// Example:
  /// ```dart
  /// int someValue = 42;
  /// String? result1 = someValue.as$<String>(); // Returns null, logs in debug mode
  /// String? result2 = someValue as String?;    // Throws TypeError
  /// ```
  ///
  /// [R] The type to cast to.
  ///
  /// Returns:
  /// - The cast value of type R if successful.
  /// - `null` if the cast fails.
  ///
  /// This method is particularly useful in scenarios where you want to
  /// attempt a cast without the risk of runtime exceptions, such as when
  /// working with dynamic data or when graceful degradation is preferred.
  /// The debug logging helps identify type mismatches during development.
  R? as$<R>() {
    if (this is R) {
      return this as R?;
    }

    // Log the cast error in debug mode
    if (kDebugMode && this != null) {
      print('CastError when trying to cast $this to $R');
    }

    return null;
  }
}
