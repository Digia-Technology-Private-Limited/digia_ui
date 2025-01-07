/// Exception thrown when configuration-related operations fail
class ConfigException implements Exception {
  final String message;
  final ConfigErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;

  ConfigException(
    this.message, {
    this.type = ConfigErrorType.unknown,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    var result = 'ConfigException(${type.name}): $message';
    if (originalError != null) {
      result += '\nOriginal error: $originalError';
    }
    if (stackTrace != null) {
      result += '\nStack trace: $stackTrace';
    }
    return result;
  }
}

/// Types of configuration errors that can occur
enum ConfigErrorType {
  /// Network-related errors (timeout, no connection, etc.)
  network,

  /// File operation errors (read/write failures, missing files)
  fileOperation,

  /// Invalid data format or parsing errors
  invalidData,

  /// Cache-related errors
  cache,

  /// Version mismatch or update issues
  version,

  /// Asset loading errors
  asset,

  /// Unknown or unspecified errors
  unknown,
}

/// Extension methods for creating specific config exceptions
extension ConfigExceptionFactory on ConfigException {
  static ConfigException network(
    String message, {
    dynamic originalError,
    StackTrace? stackTrace,
  }) =>
      ConfigException(
        message,
        type: ConfigErrorType.network,
        originalError: originalError,
        stackTrace: stackTrace,
      );

  static ConfigException fileOperation(
    String message, {
    dynamic originalError,
    StackTrace? stackTrace,
  }) =>
      ConfigException(
        message,
        type: ConfigErrorType.fileOperation,
        originalError: originalError,
        stackTrace: stackTrace,
      );

  static ConfigException invalidData(
    String message, {
    dynamic originalError,
    StackTrace? stackTrace,
  }) =>
      ConfigException(
        message,
        type: ConfigErrorType.invalidData,
        originalError: originalError,
        stackTrace: stackTrace,
      );

  static ConfigException cache(
    String message, {
    dynamic originalError,
    StackTrace? stackTrace,
  }) =>
      ConfigException(
        message,
        type: ConfigErrorType.cache,
        originalError: originalError,
        stackTrace: stackTrace,
      );
}
