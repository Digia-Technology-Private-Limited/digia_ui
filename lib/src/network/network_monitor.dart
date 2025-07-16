import 'dart:convert';
import 'package:dio/dio.dart';

class NetworkMonitor {
  static final NetworkMonitor _instance = NetworkMonitor._internal();
  factory NetworkMonitor() => _instance;
  NetworkMonitor._internal();

  int _totalBytesReceived = 0;
  int _totalBytesSent = 0;
  int _requestCount = 0;
  final List<NetworkRequestInfo> _requests = [];
  bool _isMonitoring = false;

  void startMonitoring() {
    _isMonitoring = true;
    _totalBytesReceived = 0;
    _totalBytesSent = 0;
    _requestCount = 0;
    _requests.clear();
    print('Network Monitor Started');
  }

  void stopMonitoring() {
    _isMonitoring = false;
    print('Network Monitor Stopped');
    _logFinalStats();
  }

  void _logFinalStats() {
    print('=== Network Monitor Final Stats ===');
    print('Total Bytes Received: $_totalBytesReceived bytes');
    print('Total Bytes Sent: $_totalBytesSent bytes');
    print('Total Requests: $_requestCount');
    print(
        'Network Data Consumed: ${_totalBytesReceived + _totalBytesSent} bytes');
    print('Network Requests Count: $_requestCount');
    print('===================================');
  }

  void addRequest(NetworkRequestInfo request) {
    if (!_isMonitoring) return;

    _requests.add(request);
    _totalBytesReceived += request.bytesReceived;
    _totalBytesSent += request.bytesSent;
    _requestCount++;

    print('Network Request [${request.method}] ${request.url}');
    print(
        '  Sent: ${request.bytesSent} bytes, Received: ${request.bytesReceived} bytes');
    print('  Total so far: ${_totalBytesReceived + _totalBytesSent} bytes');
  }

  int get totalBytesReceived => _totalBytesReceived;
  int get totalBytesSent => _totalBytesSent;
  int get totalDataConsumed => _totalBytesReceived + _totalBytesSent;
  int get requestCount => _requestCount;
  List<NetworkRequestInfo> get requests => List.unmodifiable(_requests);

  void reset() {
    _totalBytesReceived = 0;
    _totalBytesSent = 0;
    _requestCount = 0;
    _requests.clear();
  }
}

class NetworkRequestInfo {
  final String url;
  final String method;
  final int bytesSent;
  final int bytesReceived;
  final Duration duration;
  final int statusCode;
  final DateTime timestamp;

  NetworkRequestInfo({
    required this.url,
    required this.method,
    required this.bytesSent,
    required this.bytesReceived,
    required this.duration,
    required this.statusCode,
    required this.timestamp,
  });
}

class NetworkMonitorInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['start_time'] = DateTime.now();
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['start_time'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;

    final bytesSent = _calculateRequestSize(response.requestOptions);
    final bytesReceived = _calculateResponseSize(response);

    final requestInfo = NetworkRequestInfo(
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      bytesSent: bytesSent,
      bytesReceived: bytesReceived,
      duration: duration,
      statusCode: response.statusCode ?? 0,
      timestamp: DateTime.now(),
    );

    NetworkMonitor().addRequest(requestInfo);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['start_time'] as DateTime?;
    final duration = startTime != null
        ? DateTime.now().difference(startTime)
        : Duration.zero;

    final bytesSent = _calculateRequestSize(err.requestOptions);
    final bytesReceived =
        err.response != null ? _calculateResponseSize(err.response!) : 0;

    final requestInfo = NetworkRequestInfo(
      url: err.requestOptions.uri.toString(),
      method: err.requestOptions.method,
      bytesSent: bytesSent,
      bytesReceived: bytesReceived,
      duration: duration,
      statusCode: err.response?.statusCode ?? 0,
      timestamp: DateTime.now(),
    );

    NetworkMonitor().addRequest(requestInfo);
    handler.next(err);
  }

  int _calculateRequestSize(RequestOptions options) {
    int size = 0;

    // Headers
    options.headers.forEach((key, value) {
      size += key.length + value.toString().length;
    });

    // URL
    size += options.uri.toString().length;

    // Body
    if (options.data != null) {
      if (options.data is String) {
        size += (options.data as String).length;
      } else if (options.data is Map) {
        size += json.encode(options.data).length;
      } else if (options.data is List<int>) {
        size += (options.data as List<int>).length;
      }
    }

    return size;
  }

  int _calculateResponseSize(Response response) {
    int size = 0;

    // Headers
    response.headers.forEach((key, values) {
      size += key.length;
      for (var value in values) {
        size += value.length;
      }
    });

    // Body
    if (response.data != null) {
      if (response.data is String) {
        size += (response.data as String).length;
      } else if (response.data is Map || response.data is List) {
        size += json.encode(response.data).length;
      } else if (response.data is List<int>) {
        size += (response.data as List<int>).length;
      }
    }

    return size;
  }
}
