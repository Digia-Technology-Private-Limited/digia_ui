import 'config_resolver.dart';
import 'network/network_client.dart';

class DigiaUIService {
  final String baseUrl;
  final NetworkClient httpClient;
  final DigiaUIConfigResolver config;

  DigiaUIService(
      {required this.baseUrl, required this.httpClient, required this.config});

  DigiaUIService copyWith(
      {String? baseUrl,
      NetworkClient? httpclient,
      DigiaUIConfigResolver? config}) {
    return DigiaUIService(
        baseUrl: baseUrl ?? this.baseUrl,
        httpClient: httpclient ?? httpClient,
        config: config ?? this.config);
  }
}
