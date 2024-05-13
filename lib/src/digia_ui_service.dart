import 'config_resolver.dart';
import 'network/network_client.dart';

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
