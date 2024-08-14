import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class DUIFile {
  final String? path;
  final String? name;
  final int? size;
  final Uint8List? bytes;
  final Stream<List<int>>? readStream;
  final String? identifier;
  final XFile? xFile;

  DUIFile({
    this.path,
    this.name,
    this.size,
    this.bytes,
    this.readStream,
    this.identifier,
    this.xFile,
  });

  bool get isWeb => kIsWeb;
  bool get isMobile => !kIsWeb;

  // Factory constructor to create DUIFile from PlatformFile
  factory DUIFile.fromPlatformFile(PlatformFile platformFile) {
    if (kIsWeb) {
      return DUIFile(
        name: platformFile.name,
        size: platformFile.size,
        bytes: platformFile.bytes,
        readStream: platformFile.readStream,
        identifier: platformFile.identifier,
        xFile: platformFile.xFile,
      );
    } else {
      return DUIFile(
        path: platformFile.path,
        name: platformFile.name,
        size: platformFile.size,
        readStream: platformFile.readStream,
        identifier: platformFile.identifier,
        xFile: platformFile.xFile,
      );
    }
  }

  // Factory constructor to create DUIFile from XFile
  factory DUIFile.fromXFile(XFile xFile) {
    return DUIFile(
      name: xFile.name,
      path: xFile.path,
      xFile: xFile,
    );
  }
}
