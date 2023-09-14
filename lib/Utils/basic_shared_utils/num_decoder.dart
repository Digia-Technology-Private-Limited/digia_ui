class NumDecoder {
  static double? toDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value);
    }

    if (value is num) {
      return value.toDouble();
    }

    return null;
  }

  static double toDoubleOrDefault(dynamic value,
      {required double defaultValue}) {
    return toDouble(value) ?? defaultValue;
  }

  static int? toInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value);
    }

    if (value is num) {
      return value.toInt();
    }

    return null;
  }

  static int toIntOrDefault(dynamic value, {required int defaultValue}) {
    return toInt(value) ?? defaultValue;
  }

  static bool? toBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return bool.tryParse(value, caseSensitive: false);
    }

    return null;
  }

  static bool toBoolOrDefault(dynamic value, {required bool defaultValue}) {
    return toBool(value) ?? defaultValue;
  }
}
