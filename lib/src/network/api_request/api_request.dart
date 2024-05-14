import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config_resolver.dart';
import '../../digia_ui_client.dart';
import '../core/types.dart';

part 'api_request.g.dart';

// typedef PropertyType = ({String? key, String? value, String? type});

@JsonSerializable()
class APIModel {
  final String id;
  final String name;
  final String url;
  final HttpMethod httpMethod;
  final Map<String, dynamic> headers;
  final Map<String, dynamic> body;
  final Map<String, dynamic> variables;

  APIModel({
    required this.id,
    required this.name,
    required this.url,
    required this.httpMethod,
    required this.headers,
    required this.body,
    required this.variables,
  });

  factory APIModel.fromJson(Map<String, dynamic> json) =>
      _$APIModelFromJson(json);

  Map<String, dynamic> toJson() => _$APIModelToJson(this);
}

class APICall {
  // final String projectId;
  final DUIConfig resolver;
  // final List<APIModel> apiCalls;
  Dio? dio;

  APICall(this.resolver);

  Future<Map<String, dynamic>> execute(Map<String, dynamic> apiMap) async {
    // final resp = await dio?.request(
    //   apiCall.apiUrl,
    //   options: Options(
    //     method: apiCall.httpMethod.toString(),
    //     headers: apiCall.headers,
    //   ),
    //   data: apiCall.body,
    // );
    final apiUrl = apiMap['apis']?['courses']?['apiUrl'] ?? '';
    // final apiMethod = apiMap['apis']?['courses']?['httpMethod'] as HttpMethod;
    final apiMethod =
        _httpMethodFromString(apiMap['apis']?['courses']?['httpMethod']);
    // final resp = await DigiaUIClient.getNetworkClient().get(
    //     path: apiUrl,
    //     fromJsonT: (json) => json as dynamic,
    //     headers: defaultHeaders);
    final resp = await DigiaUIClient.getNetworkClient().request(
        apiMethod, apiUrl, (json) => json as dynamic,
        headers: defaultHeaders);
    return resp.data as Map<String, dynamic>;
  }
}

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

HttpMethod _httpMethodFromString(String method) {
  switch (method.toUpperCase()) {
    case 'GET':
      return HttpMethod.get;
    case 'POST':
      return HttpMethod.post;
    case 'PUT':
      return HttpMethod.put;
    case 'DELETE':
      return HttpMethod.delete;
    case 'PATCH':
      return HttpMethod.patch;
    default:
      throw ArgumentError('Invalid HTTP method: $method');
  }
}
