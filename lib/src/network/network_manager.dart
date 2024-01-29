import 'package:digia_ui/src/network/api_response/base_response.dart';
import 'package:digia_ui/src/project_constants.dart';
import 'package:flutter/foundation.dart';

// ignore: depend_on_referenced_packages
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
// ignore: depend_on_referenced_packages
import 'package:dio_intercept_to_curl/dio_intercept_to_curl.dart';

import 'core/http_adaptor.dart';
import 'core/types.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();

  factory NetworkManager() {
    return _instance;
  }

  NetworkManager._internal() {
    HttpAdapter.init(
        baseUrl: ProjectConstants.baseUrl,
        interceptors: kDebugMode
            ? [
                PrettyDioLogger(
                    requestHeader: true,
                    requestBody: true,
                    responseBody: true,
                    responseHeader: false,
                    error: true,
                    compact: true,
                    maxWidth: 100),
                DioInterceptToCurl(),
              ]
            : []);
  }

  Future<BaseResponse<T>> request<T>(
      HttpMethod method, String path, T Function(Object? json) fromJsonT,
      {dynamic data, Map<String, dynamic> headers = const {}}) async {
    try {
      final response = await HttpAdapter()
          .execute(path, method, data: data, headers: headers);

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
}
