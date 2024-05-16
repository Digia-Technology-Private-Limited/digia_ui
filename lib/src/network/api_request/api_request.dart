import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config_resolver.dart';
import '../../digia_ui_client.dart';
import '../core/types.dart';
import 'code_string_utils.dart';

part 'api_request.g.dart';

@JsonSerializable()
class APIModel {
  final String id;
  final String name;
  final Url url;
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

class ExecutableHttpData {
  final Url url;
  final RequestInit requestInit;

  ExecutableHttpData({required this.url, required this.requestInit});
}

class RequestInit {
  final String method;
  final Map<String, dynamic> headers;
  final String? body;

  RequestInit({required this.method, required this.headers, this.body});
}

class Url {
  final String value;
  final UrlComponent components;

  Url({
    required this.value,
    required this.components,
  });

  static fromJson(Map<String, dynamic> json) {}
}

class UrlComponent {
  final String scheme;
  final String host;
  final List<String> pathSegments;
  final List<Property> queryParams;

  UrlComponent(
      {required this.scheme,
      required this.host,
      required this.pathSegments,
      required this.queryParams});
}

class Property {
  final String key;
  final String value;
  final dynamic type;

  Property({
    required this.key,
    required this.value,
    this.type,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      key: json['key'],
      value: json['value'],
      type: json['type'],
    );
  }
}

Map<String, dynamic> _buildHeadersWithVariables(
  Map<String, dynamic> headers,
  Map<String, dynamic> variables,
) {
  return headers.map(
    (key, value) => MapEntry(
      buildDynamicString(key, variables),
      buildDynamicString(value, variables),
    ),
  );
}

String? _buildRequestBody(
  Map<String, dynamic> body,
  HttpMethod method,
) {
  if (body.isEmpty || ['GET', 'HEAD'].contains(method)) {
    return null;
  }

  return jsonEncode(body);
}

extension QueryStringBuilder on List<Property> {
  String _buildQueryString() {
    return map(
      (param) =>
          '${Uri.encodeComponent(param.key)}=${Uri.encodeComponent(param.value)}',
    ).join('&');
  }
}

String _buildUrl(UrlComponent urlComponent) {
  final scheme = urlComponent.scheme;
  final host = urlComponent.host;
  var url = '$scheme://$host';

  if (urlComponent.pathSegments.isNotEmpty) {
    url += '/${urlComponent.pathSegments.join("/")}';
  }

  if (urlComponent.queryParams.isNotEmpty) {
    final queryString = urlComponent.queryParams._buildQueryString();
    url += '?$queryString';
  }

  return url;
}

UrlComponent _fillUrlComponent(
    UrlComponent urlComponent, Map<String, dynamic> variableData) {
  final updatedPaths = urlComponent.pathSegments
      .map((path) => buildDynamicString(path, variableData))
      .toList();
  final updatedQueryParams = urlComponent.queryParams
      .map((param) => Property(
            key: buildDynamicString(param.key, variableData),
            value: buildDynamicString(param.value, variableData),
          ))
      .toList();

  return UrlComponent(
    scheme: urlComponent.scheme,
    host: urlComponent.host,
    pathSegments: updatedPaths,
    queryParams: updatedQueryParams,
  );
}

class APICall {
  final DUIConfig resolver;
  Dio? dio;

  APICall(this.resolver);

  // dynamic buildUrl(dynamic apiUrl, Map<String, dynamic> variablesMap) {
  //   if (apiUrl is String && apiUrl.isNotEmpty) {
  //     if (variablesMap.isNotEmpty) {
  //       final courseID = variablesMap['courseID'];
  //       if (courseID != null) {
  //         return '$apiUrl$courseID';
  //       }
  //     }
  //   } else {
  //     throw ArgumentError('Invalid API URL');
  //   }
  // }

  Future<Map<String, dynamic>> execute(String dataSourceId,
      Map<String, dynamic> apiMap, Map<String, dynamic> variablesMap) async {
    final apiConfig = apiMap[dataSourceId];
    if (apiConfig == null) {
      throw ArgumentError('Invalid dataSourceId: $dataSourceId');
    }

    Uri parseUrl(String urlString) {
      try {
        final uri = Uri.parse(urlString);
        return uri;
      } catch (e) {
        throw FormatException('Invalid URL format: $urlString', urlString);
      }
    }

    String getScheme(String urlString) {
      final uri = parseUrl(urlString);
      return uri.scheme;
    }

    String getHost(String urlString) {
      final uri = parseUrl(urlString);
      return uri.host;
    }

    List<String> getPathSegments(String urlString) {
      final uri = parseUrl(urlString);
      return uri.pathSegments;
    }

    List<Property> getQueryParams(String urlString) {
      final uri = parseUrl(urlString);
      return uri.queryParameters.entries
          .map((entry) => Property(key: entry.key, value: entry.value))
          .toList();
    }

    var apiUrl = apiConfig['url'];
    if (apiUrl == null) {
      throw ArgumentError('Invalid API configuration');
    }

    final id = apiConfig['id'] ?? '';
    final name = apiConfig['name'] ?? '';
    final scheme = getScheme(apiUrl); // 'https'
    final host = getHost(apiUrl); // 'jsonplaceholder.typicode.com'
    final pathSegments = getPathSegments(apiUrl); // 'posts'
    final queryParams = getQueryParams(apiUrl); // '1'

    // hardcoded way
    // apiUrl = apiUrl
    //     .replaceAll('{{path}}', pathSegments)
    //     .replaceAll('{{var}}', queryParams);

    RegExp exp = RegExp(r'{{(.*?)}}');

    Iterable<RegExpMatch> matches = exp.allMatches(apiUrl);

    for (RegExpMatch match in matches) {
      String? matched = match.group(0); // The whole match
      String? captured = match.group(1); // The captured group

      if (captured != null) {
        final value = variablesMap[captured];
        if (value != null) {
          apiUrl = apiUrl.replaceAll(matched!, value.toString());
        }
      }
    }

    final httpMethod = _httpMethodFromString(apiConfig['httpMethod']);
    final Map<String, dynamic> headers =
        _buildHeadersWithVariables(apiConfig['headers'], variablesMap);
    // headers.addAll(Map<String, dynamic>.from(defaultHeaders));

    final apiModel = APIModel(
      id: id,
      name: name,
      url: Url(
        value: apiUrl,
        components: UrlComponent(
          scheme: scheme,
          host: host,
          pathSegments: pathSegments,
          queryParams: queryParams,
        ),
      ),
      httpMethod: httpMethod,
      headers: headers as Map<String, dynamic>,
      body: apiConfig['body'] as Map<String, dynamic>,
      variables: variablesMap as Map<String, dynamic>,
    );

    final variables = apiModel.variables;
    final executableUrl = createExecutableHttpRequest(apiModel, variables);

    final response = await DigiaUIClient.getNetworkClient().request(
        httpMethod, executableUrl.url.value, (json) => json as dynamic,
        headers: headers, data: null);

    if (response.isSuccess == false) {
      throw Exception('API request failed with status code ${response.error}');
    }

    return response.data as Map<String, dynamic>;
  }

  ExecutableHttpData createExecutableHttpRequest(
      APIModel restConfig, Map<String, dynamic> variablesMap) {
    final urlComponent =
        _fillUrlComponent(restConfig.url.components, variablesMap);
    final urlString = _buildUrl(urlComponent);

    final headers =
        _buildHeadersWithVariables(restConfig.headers, variablesMap);
    final body = _buildRequestBody(restConfig.body, restConfig.httpMethod);

    return ExecutableHttpData(
      url: Url(
          value: urlString,
          components: UrlComponent(
            scheme: urlComponent.scheme,
            host: urlComponent.host,
            pathSegments: urlComponent.pathSegments,
            queryParams: urlComponent.queryParams,
          )),
      requestInit: RequestInit(
        method: restConfig.httpMethod.toString(),
        headers: headers,
        body: body,
      ),
    );

    // final requestOptions = RequestInit(
    //   method: restConfig.httpMethod.toString(),
    //   headers: headers,
    //   body: body,
    // );

    // return '$urlString\n${jsonEncode(requestOptions)}';
  }
}

// const Map<String, dynamic> defaultHeaders = {
//   'Accept': 'application/json',
//   'Content-Type': 'application/json',
// };

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
