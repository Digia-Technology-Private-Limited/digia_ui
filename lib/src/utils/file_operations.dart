import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'logger.dart';

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
      await file.writeAsString(data);
      Logger.log('File written successfully to $path/$fileName',
          tag: 'FileOperations');
      return true;
    } catch (e) {
      Logger.error('An error occurred: $e', tag: 'FileOperations');
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
      await file.writeAsBytes(data);
      Logger.log('File written successfully to $path/$fileName',
          tag: 'FileOperations');
      return true;
    } catch (e) {
      Logger.error('An error occurred: $e', tag: 'FileOperations');
      return false;
    }
  }

  @override
  Future<String?> readString(String fileName) async {
    try {
      final file = File('${await localPath}/$fileName');
      return await file.readAsString(encoding: utf8);
    } catch (e) {
      Logger.error('An error occurred: $e', tag: 'FileOperations');
      return null;
    }
  }

  @override
  Future<bool> exists(String fileName) async {
    try {
      final exists = await File('${await localPath}/$fileName').exists();
      return exists;
    } catch (e) {
      Logger.error('An error occurred: $e', tag: 'FileOperations');
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
