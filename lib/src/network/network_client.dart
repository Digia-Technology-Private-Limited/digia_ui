import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import 'api_response/base_response.dart';
import 'core/types.dart';
import 'netwok_config.dart';

String proxy = Platform.isAndroid ? '' : '';

Dio _createDigiaDio(String baseUrl, Map<String, dynamic> headers) {
  var dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 1000),
      headers: {
        ...headers,
        Headers.contentTypeHeader: Headers.jsonContentType,
      }));
  if (kDebugMode && proxy != '') {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        return HttpClient()
          ..findProxy = ((uri) => 'PROXY $proxy')
          ..badCertificateCallback = (cert, host, port) => true;
      },
    );
  }
  return dio;
}

Dio _createProjectDio(NetworkConfiguration projectNetworkConfiguration) {
  var dio = Dio(BaseOptions(
      connectTimeout: Duration(seconds: projectNetworkConfiguration.timeout),
      headers: {
        ...projectNetworkConfiguration.defaultHeaders,
      }));
  if (kDebugMode && proxy != '') {
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        return HttpClient()
          ..findProxy = ((uri) => 'PROXY $proxy')
          ..badCertificateCallback = (cert, host, port) => true;
      },
    );
  }
  return dio;
}

class NetworkClient {
  final Dio digiaDioInstance;
  final Dio projectDioInstance;

  NetworkClient(String baseUrl, Map<String, dynamic> digiaHeaders,
      NetworkConfiguration projectNetworkConfiguration)
      : digiaDioInstance = _createDigiaDio(baseUrl, digiaHeaders),
        projectDioInstance = _createProjectDio(projectNetworkConfiguration) {
    if (baseUrl.isEmpty) {
      throw 'Invalid BaseUrl';
    }

    // if (kDebugMode) {
    //   this.dio.interceptors.addAll([
    //     PrettyDioLogger(
    //       requestHeader: true,
    //       requestBody: true,
    //       responseBody: true,
    //       responseHeader: false,
    //       error: true,
    //       compact: true,
    //       // fixme if inFuture have some error related to dio, add maxWidth property and set it >100
    //     ),
    //     DioInterceptToCurl(),
    //   ]);
    // }
  }

  Future<Response<Object?>> requestProject({
    required String url,
    required HttpMethod method,
    //these headers get appended to baseHeaders, a default Dio behavior
    Map<String, dynamic>? additionalHeaders,
    Object? data,
  }) {
    //Remove headers already passed in baseHeaders
    if (additionalHeaders != null) {
      Set<String> commonKeys = projectDioInstance.options.headers.keys
          .toSet()
          .intersection(additionalHeaders.keys.toSet());
      for (var key in commonKeys) {
         additionalHeaders.remove(key);
      }
    }
  
    return projectDioInstance.request(url,
        data: data,
        options: Options(
          method: method.stringValue,
          headers: additionalHeaders
        ));
  }

  Future<Response<T>> _execute<T>(String path, HttpMethod method,
      {dynamic data, Map<String, dynamic>? headers}) async {
    return digiaDioInstance.request<T>(path,
        data: data,
        options: Options(method: method.stringValue, headers: headers));
  }

  Future<BaseResponse<T>> requestInternal<T>(
      HttpMethod method, String path, T Function(Object? json) fromJsonT,
      {dynamic data, Map<String, dynamic> headers = const {}}) async {
    try {
      final response =
          await _execute(path, method, data: data, headers: headers);

      if (response.statusCode == 200) {
        return BaseResponse.fromJson(response.data, fromJsonT);
      } else {
        return BaseResponse(
            isSuccess: false, data: null, error: {'code': response.statusCode});
      }
    } catch (e) {
      throw Exception('Error making HTTP request: $e');
    }
  }

  void replaceProjectHeaders(Map<String, String> headers) {
    projectDioInstance.options.headers = headers;
  }
}
