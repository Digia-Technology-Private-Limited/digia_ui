import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

import '../../../digia_ui.dart';
import '../../models/dui_file.dart';
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
      {required APIModel apiModel,
      required Map<String, dynamic>? args,
      StreamController<Object?>? progressStreamController}) async {
    final stopwatch = Stopwatch();
    final url = _hydrateTemplate(apiModel.url, args);
    final headers = apiModel.headers?.map((key, value) =>
        MapEntry(_hydrateTemplate(key, args), _hydrateTemplate(value, args)));
    final body = _hydrateTemplateInDynamic(apiModel.body, args);
    final bodyType = apiModel.bodyType;

    final networkClient = DigiaUIClient.getNetworkClient();
    Response<Object?> response;

    stopwatch.start();
    try {
      final preparedData = await _prepareRequestData(body, bodyType);
      if (bodyType == BodyType.multipart) {
        response = await networkClient.multipartRequestProject(
          url: url,
          method: apiModel.method,
          additionalHeaders: headers,
          data: preparedData,
          uploadProgress: (p0, p1) {
            progressStreamController?.sink.add({
              'count': p0,
              'total': p1,
              'progress': p0 / p1 * 100,
            });
            print('Progress: ${p0 / p1 * 100}');
          },
        );
      } else {
        response = await networkClient.requestProject(
            url: url,
            method: apiModel.method,
            additionalHeaders: headers,
            data: preparedData);
      }
      stopwatch.stop();
      stopwatch.reset();
      DigiaUIClient.instance.duiAnalytics?.onDataSourceSuccess(
          'api',
          url,
          {'body': preparedData},
          {'responseTime': stopwatch.elapsedMilliseconds});
      progressStreamController?.close();
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
    FormData formData = FormData();

    for (var entry in data.entries) {
      if (entry.value is DUIFile) {
        final duiFile = entry.value as DUIFile;
        if (duiFile.isWeb && duiFile.bytes != null) {
          formData.files.add(MapEntry(
            entry.key,
            await _createMultipartFileFromBytes(duiFile.bytes!, entry.key),
          ));
        } else if (duiFile.isMobile && duiFile.path != null) {
          formData.files.add(MapEntry(
            entry.key,
            await _createMultipartFile(File(duiFile.path!)),
          ));
        }
      } else if (entry.value is File) {
        formData.files.add(MapEntry(
          entry.key,
          await _createMultipartFile(entry.value),
        ));
      } else if (entry.value is List<int>) {
        formData.files.add(MapEntry(
          entry.key,
          await _createMultipartFileFromBytes(entry.value, entry.key),
        ));
      } else if (entry.value is List) {
        await _handleListValue(formData, entry.key, entry.value);
      } else {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }
    }

    return formData;
  }

  Future<void> _handleListValue(
      FormData formData, String key, List values) async {
    if (values.isEmpty) {
      formData.fields.add(MapEntry(key, '[]'));
      return;
    }

    if (values.first is DUIFile) {
      formData.files.addAll(await Future.wait(
        values.map((file) async =>
            MapEntry(key, await _createMultipartFile(file as File))),
      ));
    } else if (values.first is File) {
      formData.files.addAll(await Future.wait(
        values.map((file) async =>
            MapEntry(key, await _createMultipartFile(file as File))),
      ));
    } else if (values.first is List<int>) {
      formData.files.addAll(await Future.wait(
        values.map((bytes) async =>
            MapEntry(key, await _createMultipartFileFromBytes(bytes, key))),
      ));
    } else {
      formData.fields.add(MapEntry(key, values.toString()));
    }
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

  Future<MultipartFile> _createMultipartFileFromBytes(
      List<int> bytes, String key) async {
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
