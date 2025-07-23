class NetworkConfiguration {
  final Map<String, dynamic> defaultHeaders;
  final int timeout; // in seconds

  const NetworkConfiguration({
    required this.defaultHeaders,
    required this.timeout,
  });

  factory NetworkConfiguration.withDefaults({
    Map<String, dynamic>? defaultHeaders,
    int? timeout,
  }) {
    return NetworkConfiguration(
      defaultHeaders: defaultHeaders ?? {},
      timeout: timeout ?? 30,
    );
  }
}
