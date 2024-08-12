import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class DUIFile {
  final String? path;
  final String name;
  final int size;
  final Uint8List? bytes;
  final Stream<List<int>>? readStream;
  final String? identifier;

  DUIFile({
    this.path,
    required this.name,
    required this.size,
    this.bytes,
    this.readStream,
    this.identifier,
  }) : assert(
            (bytes != null || path != null) && !(bytes != null && path != null),
            'Only one of bytes or path should be provided.');

  bool get isWeb => kIsWeb && bytes != null && path == null;
  bool get isMobile => !kIsWeb && path != null && bytes == null;

  // Factory constructor to create DUIFile from PlatformFile
  factory DUIFile.fromPlatformFile(PlatformFile platformFile) {
    if (kIsWeb) {
      return DUIFile(
        name: platformFile.name,
        size: platformFile.size,
        bytes: platformFile.bytes,
        readStream: platformFile.readStream,
        identifier: platformFile.identifier,
      );
    } else {
      return DUIFile(
        path: platformFile.path,
        name: platformFile.name,
        size: platformFile.size,
        readStream: platformFile.readStream,
        identifier: platformFile.identifier,
      );
    }
  }

  // Factory constructor to create DUIFile from bytes (for web)
  factory DUIFile.fromBytes(String name, Uint8List bytes) {
    return DUIFile(
      name: name,
      size: bytes.length,
      bytes: bytes,
    );
  }

  // Factory constructor to create DUIFile from path (for mobile)
  factory DUIFile.fromPath(String name, String path) {
    return DUIFile(
      path: path,
      name: name,
      size: 0,
    );
  }

  // Method to get bytes from file, handling both web and mobile
  Future<Uint8List?> getBytes() async {
    if (isWeb) {
      return bytes;
    } else if (isMobile) {
      if (path == null) return null;
      try {
        final file = File(path!);
        return await file.readAsBytes();
      } catch (e) {
        print('Error reading file at $path: $e');
        return null;
      }
    }
    return null;
  }

  // Method to get file path (only valid for mobile)
  String? getPath() {
    if (isMobile) {
      return path;
    }
    throw UnsupportedError('Path is not available on web');
  }
}
