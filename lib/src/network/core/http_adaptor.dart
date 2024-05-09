import 'types.dart';
import 'package:dio/dio.dart';

class HttpAdapter {
  static final HttpAdapter _instance = HttpAdapter._internal();

  factory HttpAdapter() {
    return _instance;
  }

  static init(
      {String baseUrl = '',
      Duration connectTimeout = const Duration(seconds: 1000),
      Map<String, dynamic>? defaultHeaders = const {
        Headers.contentTypeHeader: Headers.jsonContentType
      },
      List<Interceptor> interceptors = const []}) {
    _instance._dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        headers: defaultHeaders));
    _instance._dio.interceptors.addAll(interceptors);
  }

  HttpAdapter._internal();

  late Dio _dio;

  Future<Response<T>> execute<T>(String path, HttpMethod method,
      {dynamic data, Map<String, dynamic>? headers}) async {
    return _dio.fetch<T>(RequestOptions(
        path: path, method: method.stringValue, data: data, headers: headers));
  }
}
