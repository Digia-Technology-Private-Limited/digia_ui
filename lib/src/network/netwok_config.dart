/// Configuration class for network communication settings.
///
/// This class defines network-related settings such as default headers,
/// timeout values, and other HTTP client configuration options used
/// throughout the SDK.
class NetworkConfiguration {
  /// Default headers to include with all network requests.
  final Map<String, dynamic> defaultHeaders;

  /// Request timeout in milliseconds.
  final int timeoutInMs;

  /// Creates a network configuration with the specified settings.
  const NetworkConfiguration({
    required this.defaultHeaders,
    required this.timeoutInMs,
  });

  /// Creates a network configuration with default values.
  ///
  /// [defaultHeaders] will be empty if not provided.
  /// [timeoutInMs] will be 30 seconds if not provided.
  factory NetworkConfiguration.withDefaults({
    Map<String, dynamic>? defaultHeaders,
    int? timeoutInMs,
  }) {
    return NetworkConfiguration(
      defaultHeaders: defaultHeaders ?? {},
      timeoutInMs: timeoutInMs ?? 30000,
    );
  }
}
