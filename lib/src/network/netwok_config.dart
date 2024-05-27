class NetworkConfiguration {
  final Map<String, dynamic> defaultHeaders;
  final int timeout; // in seconds

  NetworkConfiguration({
    required this.defaultHeaders,
    required this.timeout,
  });
}
