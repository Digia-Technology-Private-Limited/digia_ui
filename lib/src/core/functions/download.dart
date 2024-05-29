import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../network/core/types.dart';

// ···
Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<void> downloadFunctionsFile(String url) async {
  try {
    // Write the file
    // Send a GET request to the provided URL
    final response = await Dio().request(url,
        options: Options(
            method: HttpMethod.get.stringValue,
            responseType: ResponseType.bytes));

    if (response.statusCode == 200) {
      // Write the response body to a file
      var path = await localPath;
      final file = File(path + "/functions.js");
      await file.writeAsBytes(response.data);
      print('File downloaded successfully to $path');
    } else {
      print('Failed to download file: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

void main() async {}
