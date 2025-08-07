import 'package:flutter/foundation.dart';

/// A utility class for logging messages.
/// Uses debugPrint() when in debug mode (kDebugMode is true).
///
class Logger {
  /// Private constructor to prevent instantiation
  Logger._();

  /// Logs a message only when in debug mode
  static void log(String message, {String? tag}) {
    if (kDebugMode) {
      final logMessage = tag != null ? '[$tag] $message' : message;
      debugPrint(logMessage);
    }
  }

  /// Logs an error message only when in debug mode
  static void error(String message, {String? tag, Object? error}) {
    if (kDebugMode) {
      final logMessage =
          tag != null ? '[$tag] ERROR: $message' : 'ERROR: $message';
      final fullMessage = error != null ? '$logMessage - $error' : logMessage;
      debugPrint(fullMessage);
    }
  }

  /// Logs an info message only when in debug mode
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final logMessage =
          tag != null ? '[$tag] INFO: $message' : 'INFO: $message';
      debugPrint(logMessage);
    }
  }

  /// Logs a warning message only when in debug mode
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final logMessage =
          tag != null ? '[$tag] WARNING: $message' : 'WARNING: $message';
      debugPrint(logMessage);
    }
  }
}
