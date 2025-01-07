import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class FileOperations {
  Future<String> getLocalPath();
  Future<String?> readString(String fileName);
  Future<int> writeString(String data, String fileName);
  Future<int> writeBytes(List<int> data, String fileName);
  Future<bool> exists(String fileName);
  Future<void> delete(String fileName);
  Future<DateTime> lastModified(String fileName);
}

class FileOperationsImpl implements FileOperations {
  const FileOperationsImpl();

  @override
  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<String?> readString(String fileName) async {
    try {
      final file = File('${await getLocalPath()}/$fileName');
      return await file.readAsString(encoding: utf8);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> writeString(String data, String fileName) async {
    try {
      final file = File('${await getLocalPath()}/$fileName');
      await file.writeAsString(data);
      return 0;
    } catch (e) {
      return 1;
    }
  }

  @override
  Future<int> writeBytes(List<int> data, String fileName) async {
    try {
      final file = File('${await getLocalPath()}/$fileName');
      await file.writeAsBytes(data);
      return 0;
    } catch (e) {
      return 1;
    }
  }

  @override
  Future<bool> exists(String fileName) async {
    try {
      final file = File('${await getLocalPath()}/$fileName');
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> delete(String fileName) async {
    final file = File('${await getLocalPath()}/$fileName');
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<DateTime> lastModified(String fileName) async {
    final file = File('${await getLocalPath()}/$fileName');
    return await file.lastModified();
  }
}
