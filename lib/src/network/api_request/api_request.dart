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

  dynamic buildUrl(dynamic apiUrl, Map<String, dynamic> variablesMap) {
    if (apiUrl is String && apiUrl.isNotEmpty) {
      if (variablesMap.isNotEmpty) {
        final courseID = variablesMap['courseID'];
        if (courseID != null) {
          return '$apiUrl$courseID';
        }
      }
    } else {
      throw ArgumentError('Invalid API URL');
    }
  }

  Future<Map<String, dynamic>> execute(String dataSourceId,
      Map<String, dynamic> apiMap, Map<String, dynamic> variablesMap) async {
    final apiUrl = apiMap[dataSourceId]['url'];
    final url = buildUrl(apiUrl, variablesMap);
    final apiMethod =
        _httpMethodFromString(apiMap[dataSourceId]?['httpMethod']);
    final resp = await DigiaUIClient.getNetworkClient().request(
        apiMethod, url, (json) => json as dynamic,
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
