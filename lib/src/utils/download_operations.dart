import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../framework/utils/functional_util.dart' show as;
import '../network/core/types.dart';
import 'file_operations.dart';
import 'logger.dart';

abstract class FileDownloader {
  Future<Response?> downloadFile(String url, String fileName, {int retry = 0});
}

class FileDownloaderImpl implements FileDownloader {
  final FileOperations fileOps;
  final Dio client;

  FileDownloaderImpl({
    this.fileOps = const FileOperationsImpl(),
    Dio? client,
  }) : client = client ?? Dio();

  @override
  Future<Response?> downloadFile(String url, String fileName,
      {int retry = 0}) async {
    try {
      // Write the file
      // Send a GET request to the provided URL
      final response = await client.request(url,
          options: Options(
              sendTimeout: const Duration(seconds: 5),
              method: HttpMethod.get.stringValue,
              responseType: ResponseType.bytes));

      if (response.statusCode == 200) {
        // Write the response body to a file
        if (!kIsWeb) {
          final bool success = await fileOps.writeBytesToFile(
              as<List<int>>(response.data), fileName);
          if (!success) {
            Logger.error('Failed to write file: $fileName',
                tag: 'FileDownloader');
            await _retryFileDownload(url, fileName, retry);
          }
        }
        return response;
      } else {
        Logger.error('Failed to download file: ${response.statusCode}',
            tag: 'FileDownloader');
        await _retryFileDownload(url, fileName, retry);
      }
    } catch (e) {
      Logger.error('An error occurred: $e', tag: 'FileDownloader');
      await _retryFileDownload(url, fileName, retry);
    }
    return null;
  }

  Future<Response?> _retryFileDownload(
      String url, String fileName, int retry) async {
    if (retry < 2) {
      return await downloadFile(url, fileName, retry: retry + 1);
    } else {
      Logger.error('3 retries done.. $fileName fetch failed',
          tag: 'FileDownloader');
      return null;
    }
  }
}
