import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<int> writeStringToFile(String data, String fileName) async {
  try {
    // Write the file
    // Send a GET request to the provided URL
    var path = await localPath;
    final file = File('$path/$fileName');
    file.writeAsString(data);
    print('File written successfully to $path/$fileName');
    return 0;
  } catch (e) {
    print('An error occurred: $e');
    return 1;
  }
}

Future<int> writeBytesToFile(List<int> data, String fileName) async {
  try {
    // Write the file
    // Send a GET request to the provided URL
    var path = await localPath;
    final file = File('$path/$fileName');
    file.writeAsBytes(data);
    print('File written successfully to $path/$fileName');
    return 0;
  } catch (e) {
    print('An error occurred: $e');
    return 1;
  }
}

Future<String?> readFileString(String fileName) async {
  try {
    final file = File('${await localPath}/$fileName');
    return await file.readAsString(encoding: utf8);
  } catch (e) {
    print('An error occurred: $e');
    return null;
  }
}

Future<bool> doesFileExist(String fileName) async {
  try {
    final exists = await File('${await localPath}/$fileName').exists();
    return exists;
  } catch (e) {
    print('An error occurred: $e');
    return false;
  }
}


