import 'package:dio/dio.dart';
import '../../Utils/file_operations.dart';
import '../../network/core/types.dart';

Future<void> downloadFunctionsFile(String url, {int retry = 0}) async {
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
      var status = await writeBytesToFile(response.data, 'functions.js');
      if (status != 0) {
        print('Failed to write file: functions.js');
        await retryDownload(url, retry);
      }
    } else {
      print('Failed to download file: ${response.statusCode}');
      await retryDownload(url, retry);
    }
  } catch (e) {
    print('An error occurred: $e');
    await retryDownload(url, retry);
  }
}

Future<void> retryDownload(String url, int retry) async {
  if (retry < 2) {
    await downloadFunctionsFile(url, retry: retry + 1);
  } else {
    print('3 retries done.. Function fetch failed');
  }
}
