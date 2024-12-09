import 'package:cross_file/cross_file.dart';
import 'package:digia_expr/digia_expr.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class AdaptedFile implements ExprInstance {
  String? path;
  String? name;
  int? size;
  Uint8List? bytes;
  Stream<List<int>>? readStream;
  String? identifier;
  XFile? xFile;

  AdaptedFile();

  void setData({
    final String? path,
    final String? name,
    final int? size,
    final Uint8List? bytes,
    final Stream<List<int>>? readStream,
    final String? identifier,
    final XFile? xFile,
  }) {
    this.name = name;
    this.path = path;
    this.size = size;
    this.bytes = bytes;
    this.readStream = readStream;
    this.identifier = identifier;
    this.xFile = xFile;
  }

  bool get isWeb => kIsWeb;
  bool get isMobile => !kIsWeb;

  // Factory constructor to create AdaptedFile from PlatformFile
  factory AdaptedFile.fromPlatformFile(PlatformFile platformFile) {
    return AdaptedFile()
      ..path = kIsWeb ? null : platformFile.path
      ..name = platformFile.name
      ..size = platformFile.size
      ..bytes = platformFile.bytes
      ..readStream = platformFile.readStream
      ..identifier = platformFile.identifier;
  }

  // Factory constructor to create AdaptedFile from XFile
  factory AdaptedFile.fromXFile(XFile xFile) {
    return AdaptedFile()
      ..name = xFile.name
      ..path = xFile.path
      ..xFile = xFile;
  }

  @override
  Object? getField(String data) => switch (data) {
        'name' => name,
        'size' => size,
        'identifier' => identifier,
        _ => null,
      };
}
