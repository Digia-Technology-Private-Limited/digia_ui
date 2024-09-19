class NumUtil {
  /// Attempts to parse a dynamic input into a double.
  ///
  /// Handles the following cases:
  /// - String representations of numbers, including hexadecimal
  /// - Special string values 'inf' or 'infinity' (case-insensitive)
  /// - Numeric types (int, double)
  ///
  /// Returns:
  /// - A valid double if parsing is successful
  /// - double.infinity for 'inf' or 'infinity' strings
  /// - null if parsing fails or input is of an unsupported type
  static double? toDouble(dynamic input) {
    if (input is String) {
      // Check for infinity representations
      if (['inf', 'infinity'].contains(input.toLowerCase())) {
        return double.infinity;
      }

      // Handle hexadecimal strings
      if (input.startsWith('0x')) {
        return int.tryParse(input.substring(2), radix: 16)?.toDouble();
      }

      // Attempt to parse regular numeric strings
      return double.tryParse(input);
    }

    // Handle numeric types
    if (input is num) {
      return input.toDouble();
    }

    // Return null for unsupported types
    return null;
  }

  /// Attempts to parse a dynamic input into an integer.
  ///
  /// Handles the following cases:
  /// - String representations of numbers, including hexadecimal
  /// - Numeric types (int, double)
  ///
  /// Returns:
  /// - A valid integer if parsing is successful
  /// - null if parsing fails or input is of an unsupported type
  static int? toInt(dynamic value) {
    if (value is String) {
      // Handle hexadecimal strings
      if (value.toLowerCase().startsWith('0x')) {
        return int.tryParse(value.substring(2), radix: 16);
      }

      // Attempt to parse regular numeric strings
      return int.tryParse(value);
    }

    // Handle numeric types
    if (value is num) {
      return value.toInt();
    }

    // Return null for unsupported types
    return null;
  }

  /// Attempts to parse a dynamic input into a boolean value.
  ///
  /// Handles the following cases:
  /// - Boolean values
  /// - String representations of boolean values (case-insensitive)
  ///
  /// Returns:
  /// - A valid boolean if parsing is successful
  /// - null if parsing fails or input is of an unsupported type
  static bool? toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return bool.tryParse(value, caseSensitive: false);
    }

    return null;
  }
}
