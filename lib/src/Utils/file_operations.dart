import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

abstract class FileOperations {
  Future<String> get localPath;
  Future<bool> writeStringToFile(String data, String fileName);
  Future<bool> writeBytesToFile(List<int> data, String fileName);
  Future<String?> readString(String fileName);
  Future<bool> exists(String fileName);
  Future<void> delete(String fileName);
  Future<DateTime> lastModified(String fileName);
}

class FileOperationsImpl implements FileOperations {
  const FileOperationsImpl();

  @override
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<bool> writeStringToFile(String data, String fileName) async {
    try {
      // Write the file
      // Send a GET request to the provided URL
      var path = await localPath;
      final file = File('$path/$fileName');
      file.writeAsString(data);
      print('File written successfully to $path/$fileName');
      return true;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  @override
  Future<bool> writeBytesToFile(List<int> data, String fileName) async {
    try {
      // Write the file
      // Send a GET request to the provided URL
      var path = await localPath;
      final file = File('$path/$fileName');
      file.writeAsBytes(data);
      print('File written successfully to $path/$fileName');
      return true;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  @override
  Future<String?> readString(String fileName) async {
    try {
      final file = File('${await localPath}/$fileName');
      return await file.readAsString(encoding: utf8);
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }

  @override
  Future<bool> exists(String fileName) async {
    try {
      final exists = await File('${await localPath}/$fileName').exists();
      return exists;
    } catch (e) {
      print('An error occurred: $e');
      return false;
    }
  }

  @override
  Future<void> delete(String fileName) async {
    final file = File('${await localPath}/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<DateTime> lastModified(String fileName) async {
    final file = File('${await localPath}/$fileName');
    return await file.lastModified();
  }
}
