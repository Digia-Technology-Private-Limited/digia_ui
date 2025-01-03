import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../framework/utils/functional_util.dart';
import '../network/core/types.dart';
import 'file_operations.dart';

Future<Response?> downloadFile(String url, String fileName,
    {int retry = 0}) async {
  try {
    // Write the file
    // Send a GET request to the provided URL
    final response = await Dio().request(url,
        options: Options(
            sendTimeout: const Duration(seconds: 5),
            method: HttpMethod.get.stringValue,
            responseType: ResponseType.bytes));

    if (response.statusCode == 200) {
      // Write the response body to a file
      if (!kIsWeb) {
        var status =
            await writeBytesToFile(as<List<int>>(response.data), fileName);
        if (status != 0) {
          print('Failed to write file: $fileName');
          await retryFileDownload(url, fileName, retry);
        }
      }
      return response;
    } else {
      print('Failed to download file: ${response.statusCode}');
      await retryFileDownload(url, fileName, retry);
    }
  } catch (e) {
    print('An error occurred: $e');
    await retryFileDownload(url, fileName, retry);
  }
  return null;
}

Future<Response?> retryFileDownload(
    String url, String fileName, int retry) async {
  if (retry < 2) {
    return await downloadFile(url, fileName, retry: retry + 1);
  } else {
    print('3 retries done.. $fileName fetch failed');
    return null;
  }
}
