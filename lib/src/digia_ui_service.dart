import 'package:digia_ui/src/network/network_client.dart';
import 'package:dio/dio.dart';

class DigiaUIService {
  final String baseUrl;
  late NetworkClient httpClient;

  DigiaUIService({required this.baseUrl, Dio? dio})
      : httpClient = NetworkClient(dio, baseUrl);
}
