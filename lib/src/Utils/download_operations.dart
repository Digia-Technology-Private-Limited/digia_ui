import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../framework/utils/functional_util.dart';
import '../network/core/types.dart';
import 'file_operations.dart';

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
            print('Failed to write file: $fileName');
            await _retryFileDownload(url, fileName, retry);
          }
        }
        return response;
      } else {
        print('Failed to download file: ${response.statusCode}');
        await _retryFileDownload(url, fileName, retry);
      }
    } catch (e) {
      print('An error occurred: $e');
      await _retryFileDownload(url, fileName, retry);
    }
    return null;
  }

  Future<Response?> _retryFileDownload(
      String url, String fileName, int retry) async {
    if (retry < 2) {
      return await downloadFile(url, fileName, retry: retry + 1);
    } else {
      print('3 retries done.. $fileName fetch failed');
      return null;
    }
  }
}
