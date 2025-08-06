/// Configuration class for network communication settings.
///
/// This class defines network-related settings such as default headers,
/// timeout values, and other HTTP client configuration options used
/// throughout the SDK.
class NetworkConfiguration {
  /// Default headers to include with all network requests.
  final Map<String, dynamic> defaultHeaders;

  /// Request timeout in seconds.
  final int timeoutInSeconds;

  /// Creates a network configuration with the specified settings.
  const NetworkConfiguration({
    required this.defaultHeaders,
    required this.timeoutInSeconds,
  });

  /// Creates a network configuration with default values.
  ///
  /// [defaultHeaders] will be empty if not provided.
  /// [timeoutInSeconds] will be 30 seconds if not provided.
  factory NetworkConfiguration.withDefaults({
    Map<String, dynamic>? defaultHeaders,
    int? timeoutInSeconds,
  }) {
    return NetworkConfiguration(
      defaultHeaders: defaultHeaders ?? {},
      timeoutInSeconds: timeoutInSeconds ?? 30,
    );
  }
}
