import 'package:flutter/foundation.dart';

import '../../utils/logger.dart';
import 'json_util.dart';
import 'num_util.dart';
import 'types.dart';

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
          // Use NumUtil for num conversion
          const (num) => NumUtil.toNum(value) as R?,
          // Map conversion
          const (JsonLike) => _toJsonLike(value) as R?,
          // List conversion
          const (List) || const (List<Object>) => _toList(value) as R?,
          // For any other type, attempt a safe cast
          _ => value.as$<R>()
        } ??
        // If all conversions fail, return the default value
        defaultValue;
  }

  // Helper method for List conversion
  JsonLike? _toJsonLike(Object? value) {
    if (value is JsonLike) return value;
    if (value is! String) return null;
    final parsed = tryJsonDecode(value);
    return parsed is JsonLike ? parsed : null;
  }

  // Helper method for List conversion
  List<Object>? _toList(Object? value) {
    if (value is List) return value.cast<Object>();
    if (value is! String) return null;
    final parsed = tryJsonDecode(value);

    return parsed is List ? parsed.cast<Object>() : null;
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
      return this as R;
    }

    // Log the cast error in debug mode
    if (kDebugMode && this != null) {
      Logger.error('CastError when trying to cast $this to $R',
          tag: 'ObjectUtil', error: TypeError());
    }

    return null;
  }
}
