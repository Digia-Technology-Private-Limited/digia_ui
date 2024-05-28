import 'package:dio/dio.dart';

import '../../../digia_ui.dart';
import '../../network/api_request/api_request.dart';

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  ApiHandler._();

  static ApiHandler get instance => _instance;

  Future<Object?> execute(
      {required APIModel apiModel, required Map<String, dynamic>? args}) async {
    final stopwatch = Stopwatch();
    final url = _hydrateTemplate(apiModel.url, args);
    final headers = apiModel.headers?.map((key, value) =>
        MapEntry(_hydrateTemplate(key, args), _hydrateTemplate(value, args)));

    final networkClient = DigiaUIClient.getNetworkClient();
    stopwatch.start();
    try {
      final response = await networkClient.requestProject(
          url: url,
          method: apiModel.method,
          additionalHeaders: headers,
          data: apiModel.body);
      stopwatch.stop();
      DigiaUIClient.instance.duiAnalytics?.onDataSourceSuccess(
          'api',
          url,
          {'body': apiModel.body},
          {'responseTime': stopwatch.elapsedMilliseconds});
      return response.data;
    } on DioException catch (e) {
      DigiaUIClient.instance.duiAnalytics?.onDataSourceError('api', url, {
        'request': e.requestOptions,
        'statusCode': e.response?.statusCode,
        'data': e.response?.data,
        'errType': e.type,
        'message': e.message,
        'error': e.error
      });
      rethrow;
    } catch (e) {
      DigiaUIClient.instance.duiAnalytics?.onDataSourceError(
          'api', url, {'errType': 'internal_error', 'error': e});
      rethrow;
    }
  }

  String _hydrateTemplate(String template, Map<String, dynamic>? values) {
    final regex = RegExp(r'\{\{(\w+)\}\}');
    return template.replaceAllMapped(regex, (match) {
      final variableName = match.group(1);
      return values?[variableName]?.toString() ??
          match.group(0)!; // Keep original if value not found
    });
  }
}
