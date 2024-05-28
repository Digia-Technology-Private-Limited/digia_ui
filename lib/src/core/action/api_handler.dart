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
    final body = _hydrateTemplateInDynamic(apiModel.body, args);

    final networkClient = DigiaUIClient.getNetworkClient();

    stopwatch.start();
    try {
      final response = await networkClient.requestProject(
          url: url,
          method: apiModel.method,
          additionalHeaders: headers,
          data: body);
      stopwatch.stop();
      stopwatch.reset();
      DigiaUIClient.instance.duiAnalytics?.onDataSourceSuccess(
          'api',
          url,
          {'body': apiModel.body},
          {'responseTime': stopwatch.elapsedMilliseconds});
      return response.data;
    } on DioException catch (e) {
      DigiaUIClient.instance.duiAnalytics?.onDataSourceError(
          'api',
          url,
          ApiServerInfo(e.response?.data, e.requestOptions,
              e.response?.statusCode, e.error, e.message));
      rethrow;
    } catch (e) {
      DigiaUIClient.instance.duiAnalytics?.onDataSourceError(
          'api', url, ApiServerInfo(null, null, -1, e, null));
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

  dynamic _hydrateTemplateInDynamic(
      dynamic json, Map<String, dynamic>? values) {
    if (json == null) return null;

    if (json is num || json is bool) return json;

    if (json is Map<String, dynamic>) {
      return json.map((key, value) => MapEntry(
          _hydrateTemplateInDynamic(key, values),
          _hydrateTemplateInDynamic(value, values)));
    }

    if (json is List) {
      return json.map((e) => _hydrateTemplateInDynamic(json, values)).toList();
    }

    if (json is! String) return json;

    final regex = RegExp(r'^\{\{(\w+)\}\}$');
    final match = regex.firstMatch(json);
    if (match != null) {
      final variableName = match.group(1);

      return values?[variableName];
    }

    // Checking for case of String intperpolation
    final innerVarRegex = RegExp(r'\{\{(\w+)\}\}');
    final innerVarMatch = innerVarRegex.firstMatch(json);
    if (innerVarMatch == null) return json;

    return json.replaceAllMapped(innerVarRegex, (match) {
      final variableName = match.group(1);
      return values?[variableName]?.toString() ?? match.group(0)!;
    });
  }
}
