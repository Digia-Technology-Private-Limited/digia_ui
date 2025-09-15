import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/logger.dart';
import '../../data_type/adapted_types/file.dart';
import '../../expr/scope_context.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class FilePickerProcessor extends ActionProcessor<FilePickerAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    FilePickerAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final file =
        action.selectedPageState?.evaluate(scopeContext) as AdaptedFile?;
    final fileType = action.fileType;
    final sizeLimit = action.sizeLimit?.evaluate(scopeContext);
    final showToast = action.showToast ?? true;
    final isMultiSelect = action.isMultiSelected ?? false;

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'fileType': fileType,
        'sizeLimit': sizeLimit,
        'isMultiSelect': isMultiSelect,
        'showToast': showToast,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    final type = toFileType(fileType);

    List<PlatformFile>? platformFiles;
    try {
      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stage': 'file_picker_started',
          'fileType': fileType,
          'sizeLimit': sizeLimit,
          'isMultiSelect': isMultiSelect,
          'showToast': showToast,
        },
        observabilityContext: observabilityContext,
      );

      // Compression has to be set to 0, because of this issue:
      // https://github.com/miguelpruivo/flutter_file_picker/issues/1534
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
          type: type,
          allowMultiple: isMultiSelect,
          allowedExtensions: type == FileType.custom ? ['pdf'] : null,
          compressionQuality: 0);

      if (pickedFile == null) {
        // User canceled the picker
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: null,
          stackTrace: null,
          observabilityContext: observabilityContext,
        );
        return null;
      }

      if (!context.mounted) {
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: null,
          stackTrace: null,
          observabilityContext: observabilityContext,
        );
        return null;
      }

      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stage': 'files_picked',
          'pickedFileCount': pickedFile.count,
          'pickedFileNames': pickedFile.names,
        },
        observabilityContext: observabilityContext,
      );

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
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: e,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
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

        executionContext?.notifyProgress(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          details: {
            'stage': 'files_processed',
            'finalFileCount': finalFiles.length,
            'fileSet': file != null,
          },
        );
      } catch (e) {
        Logger.error('Error: $e', tag: 'FilePickerProcessor', error: e);
        executionContext?.notifyComplete(
          id: id,
          parentActionId: parentActionId,
          descriptor: desc,
          error: e,
          stackTrace: StackTrace.current,
          observabilityContext: observabilityContext,
        );
        return null;
      }
    }

    executionContext?.notifyComplete(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      error: null,
      stackTrace: null,
      observabilityContext: observabilityContext,
    );

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

void showExceedSizeLimitToast(FToast toast, dynamic file, double? sizeLimit) {
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
