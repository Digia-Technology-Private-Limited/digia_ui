import 'package:digia_ui/src/network/network_client.dart';

import 'config_resolver.dart';

class DigiaUIService {
  final String baseUrl;
  final NetworkClient httpClient;
  final DUIConfig config;

  DigiaUIService(
      {required this.baseUrl, required this.httpClient, required this.config});

  DigiaUIService copyWith(
      {String? baseUrl, NetworkClient? httpclient, DUIConfig? config}) {
    return DigiaUIService(
        baseUrl: baseUrl ?? this.baseUrl,
        httpClient: httpclient ?? httpClient,
        config: config ?? this.config);
  }
}
