import 'package:digia_ui/src/digia_ui_sdk.dart';
import 'package:dio/dio.dart';
import 'package:dio_intercept_to_curl/dio_intercept_to_curl.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_response/base_response.dart';
import 'core/types.dart';

Dio _createDefaultDio(String baseUrl) {
  return Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 1000),
      headers: {Headers.contentTypeHeader: Headers.jsonContentType}));
}

class NetworkClient {
  final Dio dio;

  NetworkClient(Dio? dio, String baseUrl)
      : dio = dio ?? _createDefaultDio(baseUrl) {
    if (baseUrl.isEmpty) {
      throw 'Invalid BaseUrl';
    }

    if (kDebugMode) {
      this.dio.interceptors.addAll([
        PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            responseHeader: false,
            error: true,
            compact: true,
            maxWidth: 100),
        DioInterceptToCurl(),
      ]);
    }
  }

  Future<Response<T>> _execute<T>(String path, HttpMethod method,
      {dynamic data, Map<String, dynamic>? headers}) async {
    String urlPath = '';
    if (path.contains('http')) {
      urlPath = path;
    } else {
      urlPath = dio.options.baseUrl + path;
    }
    return dio.fetch<T>(RequestOptions(
        path: urlPath,
        method: method.stringValue,
        data: data,
        headers: headers));
  }

  Future<BaseResponse<T>> request<T>(
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

  Future<BaseResponse<T>> post<T>(
      {required String path,
      required T Function(Object? json) fromJsonT,
      required dynamic data,
      Map<String, dynamic> headers = const {}}) async {
    return request(HttpMethod.post, path, fromJsonT,
        data: data, headers: headers);
  }
}
