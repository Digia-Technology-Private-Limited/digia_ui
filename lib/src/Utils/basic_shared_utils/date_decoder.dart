class DateDecoder {
  static DateTime? toDate(dynamic date) {
    if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    }

    if (date is DateTime) {
      return date;
    }

    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    }

    return null;
  }
}
