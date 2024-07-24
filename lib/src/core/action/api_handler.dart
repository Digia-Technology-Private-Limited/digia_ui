import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import '../../../digia_ui.dart';
import '../../network/api_request/api_request.dart';
import '../../network/core/types.dart';

const Map<String, String> defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

class ApiHandler {
  static final ApiHandler _instance = ApiHandler._();

  ApiHandler._();

  static ApiHandler get instance => _instance;

  Future<Response<Object?>> execute(
      {required APIModel apiModel, required Map<String, dynamic>? args}) async {
    final stopwatch = Stopwatch();
    final url = _hydrateTemplate(apiModel.url, args);
    final headers = apiModel.headers?.map((key, value) =>
        MapEntry(_hydrateTemplate(key, args), _hydrateTemplate(value, args)));
    final body = _hydrateTemplateInDynamic(apiModel.body, args);
    final bodyType = apiModel.bodyType;

    final networkClient = DigiaUIClient.getNetworkClient();

    stopwatch.start();
    try {
      final preparedData = await _prepareRequestData(body, bodyType);
      final response = await networkClient.requestProject(
          url: url,
          method: apiModel.method,
          additionalHeaders: headers,
          data: preparedData);
      stopwatch.stop();
      stopwatch.reset();
      DigiaUIClient.instance.duiAnalytics?.onDataSourceSuccess(
          'api',
          url,
          {'body': preparedData},
          {'responseTime': stopwatch.elapsedMilliseconds});
      return response;
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

  Future<dynamic> _prepareRequestData(dynamic body, BodyType? bodyType) async {
    if (bodyType == BodyType.multipart) {
      return await _createFormData(body);
    }
    return body;
  }

  Future<FormData> _createFormData(dynamic data) async {
    Map<String, dynamic> formDataMap = {};

    for (var entry in data.entries) {
      if (entry.value is File) {
        File file = entry.value;
        formDataMap[entry.key] = await _createMultipartFile(file);
      } else if (entry.value is List) {
        List values = entry.value;
        if (values.isNotEmpty && values.first is File) {
          formDataMap[entry.key] = await Future.wait(
              values.map((file) => _createMultipartFile(file)));
        } else if (values.isNotEmpty && values.first is List<int>) {
          formDataMap[entry.key] = values
              .map((bytes) => _createMultipartFileFromBytes(bytes, entry.key))
              .toList();
        } else {
          formDataMap[entry.key] = values;
        }
      } else if (entry.value is List<int>) {
        formDataMap[entry.key] =
            _createMultipartFileFromBytes(entry.value, entry.key);
      } else {
        formDataMap[entry.key] = entry.value;
      }
    }

    return FormData.fromMap(formDataMap);
  }

  Future<MultipartFile> _createMultipartFile(File file) async {
    String fileName = file.path.split('/').last;
    String? mimeType = mime(fileName);
    return await MultipartFile.fromFile(
      file.path,
      filename: fileName,
      contentType: _getMediaType(mimeType),
    );
  }

  MultipartFile _createMultipartFileFromBytes(List<int> bytes, String key) {
    String? mimeType = mime(key);
    return MultipartFile.fromBytes(
      bytes,
      filename: key,
      contentType: _getMediaType(mimeType),
    );
  }

  MediaType? _getMediaType(String? mimeType) {
    if (mimeType == null) return null;
    final parts = mimeType.split('/');
    if (parts.length == 2) {
      return MediaType(parts[0], parts[1]);
    }
    return null;
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
      return json.map((e) => _hydrateTemplateInDynamic(e, values)).toList();
    }

    if (json is! String) return json;

    final regex = RegExp(r'^\{\{(\w+)\}\}$');
    final match = regex.firstMatch(json);
    if (match != null) {
      final variableName = match.group(1);
      return values?[variableName];
    }

    // Checking for case of String interpolation
    final innerVarRegex = RegExp(r'\{\{(\w+)\}\}');
    final innerVarMatch = innerVarRegex.firstMatch(json);
    if (innerVarMatch == null) return json;

    return json.replaceAllMapped(innerVarRegex, (match) {
      final variableName = match.group(1);
      return values?[variableName]?.toString() ?? match.group(0)!;
    });
  }
}
