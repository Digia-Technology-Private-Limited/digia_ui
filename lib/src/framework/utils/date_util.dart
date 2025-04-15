class DateUtil {
  /// Converts various date formats to a DateTime object.
  ///
  /// Accepts String, DateTime, and int (milliseconds since epoch) as input.
  /// Returns null if the input cannot be converted to a valid DateTime.
  static DateTime? toDate(Object? date) {
    if (date is DateTime) {
      // If it's already a DateTime, return it as is
      return date;
    }

    if (date is String) {
      // Try to parse the string,
      return DateTime.tryParse(date);
    }

    if (date is int) {
      // Convert milliseconds since epoch to DateTime
      return DateTime.fromMillisecondsSinceEpoch(date);
    }

    // Return null for any other input type
    return null;
  }
}
