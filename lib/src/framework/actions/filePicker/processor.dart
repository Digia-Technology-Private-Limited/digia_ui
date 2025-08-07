import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/logger.dart';
import '../../data_type/adapted_types/file.dart';
import '../../expr/scope_context.dart';
import '../base/processor.dart';
import 'action.dart';

class FilePickerProcessor extends ActionProcessor<FilePickerAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    FilePickerAction action,
    ScopeContext? scopeContext,
  ) async {
    final file =
        action.selectedPageState?.evaluate(scopeContext) as AdaptedFile?;
    final fileType = action.fileType;
    final sizeLimit = action.sizeLimit?.evaluate(scopeContext);
    final showToast = action.showToast ?? true;
    final isMultiSelect = action.isMultiSelected ?? false;

    final type = toFileType(fileType);

    List<PlatformFile>? platformFiles;
    // bool isSinglePick;
    try {
      // Compression has to be set to 0, because of this issue:
      // https://github.com/miguelpruivo/flutter_file_picker/issues/1534
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
          type: type,
          allowMultiple: isMultiSelect,
          allowedExtensions: type == FileType.custom ? ['pdf'] : null,
          compressionQuality: 0);

      // isSinglePick = pickedFile?.isSinglePick ?? true;

      if (pickedFile == null) {
        // User canceled the picker
        return null;
      }

      logAction(
        action.actionType.value,
        {
          'fileType': fileType,
          'sizeLimit': sizeLimit,
          'isMultiSelect': isMultiSelect,
          'showToast': showToast,
          'pickedFileCount': pickedFile.count,
          'pickedFile(s)': pickedFile.names,
        },
      );

      if (!context.mounted) {
        return null;
      }
      final toast = FToast().init(context);

      if (sizeLimit != null && showToast) {
        platformFiles = pickedFile.files.where((file) {
          if (file.size > sizeLimit * 1024) {
            showExceedSizeLimitToast(toast, file, sizeLimit);
            return false;
          }
          return true;
        }).toList();
      } else {
        platformFiles = pickedFile.files;
      }
    } catch (e) {
      Logger.error('Error picking file: $e',
          tag: 'FilePickerProcessor', error: e);
      return null;
    }

    if (platformFiles.isNotEmpty) {
      try {
        List<AdaptedFile> finalFiles = platformFiles.map((platformFile) {
          return AdaptedFile.fromPlatformFile(platformFile);
        }).toList();

        final files = finalFiles.first;

        if (file != null) {
          file.setDataFromAdaptedFile(files);
        }
      } catch (e) {
        Logger.error('Error: $e', tag: 'FilePickerProcessor', error: e);
      }
    }

    return null;
  }
}

FileType toFileType(String? fileType) {
  if (fileType == null) {
    return FileType.any;
  }
  switch (fileType.toLowerCase()) {
    case 'audio':
      return FileType.audio;
    case 'pdf':
      return FileType.custom;
    default:
      return FileType.any;
  }
}

showExceedSizeLimitToast(FToast toast, dynamic file, double? sizeLimit) {
  toast.showToast(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Text(
        'File ${file.name} of size ${(file.size / 1000).toStringAsFixed(2)}kB selected exceeds the size limit of ${sizeLimit}kB.',
        style: const TextStyle(color: Colors.white),
      ),
    ),
    gravity: ToastGravity.BOTTOM,
    toastDuration: const Duration(seconds: 2),
  );
}
