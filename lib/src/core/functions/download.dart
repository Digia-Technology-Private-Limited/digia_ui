import 'package:dio/dio.dart';
import '../../Utils/file_operations.dart';
import '../../framework/utils/functional_util.dart';
import '../../network/core/types.dart';

Future<bool> downloadFunctionsFile(String url, String fileName,
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
      var status =
          await writeBytesToFile(as<List<int>>(response.data), fileName);
      if (status != 0) {
        print('Failed to write file: functions.js');
        return await retryJsFileDownload(url, fileName, retry);
      }
      return true;
    } else {
      print('Failed to download file: ${response.statusCode}');
      return await retryJsFileDownload(url, fileName, retry);
    }
  } catch (e) {
    print('An error occurred: $e');
    return await retryJsFileDownload(url, fileName, retry);
  }
}

Future<Response?> downloadAppConfigFile(String url, String fileName,
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
      var status =
          await writeBytesToFile(as<List<int>>(response.data), fileName);
      if (status != 0) {
        print('Failed to write file: appConfig.json');
        await retryConfigFileDownload(url, fileName, retry);
      }
      return response;
    } else {
      print('Failed to download file: ${response.statusCode}');
      await retryConfigFileDownload(url, fileName, retry);
    }
  } catch (e) {
    print('An error occurred: $e');
    await retryConfigFileDownload(url, fileName, retry);
  }
  return null;
}

Future<bool> retryJsFileDownload(String url, String fileName, int retry) async {
  if (retry < 2) {
    return await downloadFunctionsFile(url, fileName, retry: retry + 1);
  } else {
    print('3 retries done.. Function fetch failed');
    return false;
  }
}

Future<Response?> retryConfigFileDownload(
    String url, String fileName, int retry) async {
  if (retry < 2) {
    return await downloadAppConfigFile(url, fileName, retry: retry + 1);
  } else {
    print('3 retries done.. AppConfig fetch failed');
    return null;
  }
}
