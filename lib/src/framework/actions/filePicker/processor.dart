import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../core/action/api_handler.dart';
import '../../../core/page/dui_page_bloc.dart';
import '../../../models/dui_file.dart';
import '../../base/state_context_provider.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../resource_provider.dart';
import '../base/action_flow.dart';
import '../base/processor.dart';
import 'action.dart';

class FilePickerProcessor extends ActionProcessor<FilePickerAction> {
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext,
  ) executeActionFlow;

  FilePickerProcessor({
    required this.executeActionFlow,
  });

  @override
  Future<Object?>? execute(
    BuildContext context,
    FilePickerAction action,
    ScopeContext? scopeContext,
  ) async {
    //  final bloc = context.tryRead<DUIPageBloc>();
    //   if (bloc == null) {
    //     throw 'Action.filePicker called on a widget which is not wrapped in DUIPageBloc';
    //   }
    final stateContext = StateContextProvider.getOriginState(context);

    final fileType = action.fileType;
    final sizeLimit = action.sizeLimit?.evaluate(scopeContext);
    final showToast = action.showToast ?? true;
    final isMultiSelect = action.isMultiSelected ?? false;
    final selectedPageState = action.selectedPageState;
    final rebuildPage = action.rebuildPage ?? false;

    final type = toFileType(fileType);

    List<PlatformFile>? platformFiles;
    bool isSinglePick;
    try {
      // Compression has to be set to 0, because of this issue:
      // https://github.com/miguelpruivo/flutter_file_picker/issues/1534
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
          type: type,
          allowMultiple: isMultiSelect,
          allowedExtensions: type == FileType.custom ? ['pdf'] : null,
          compressionQuality: 0);

      isSinglePick = pickedFile?.isSinglePick ?? true;

      if (pickedFile == null) {
        // User canceled the picker
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
      print('Error picking file: $e');
      return null;
    }

    if (platformFiles.isNotEmpty) {
      try {
        List<DUIFile> finalFiles = platformFiles.map((platformFile) {
          return DUIFile.fromPlatformFile(platformFile);
        }).toList();

        final variables = stateContext.stateVariables;
        final events = [
          {
            'variableName': selectedPageState,
            'value': isSinglePick ? finalFiles.first : finalFiles,
          }
        ];

        final updatesMap = Map.fromEntries(variables.map(
          (update) => MapEntry(
              selectedPageState, isSinglePick ? finalFiles.first : finalFiles),
        ));
        stateContext.setValues(updatesMap, notify: rebuildPage);

        bloc.add(SetStateEvent(
          events: events
              .where((e) => variables?[e['variableName']] != null)
              .map((e) => SingleSetStateEvent(
                    variableName: e['variableName'],
                    context: context,
                    value: e['value'],
                  ))
              .toList(),
          rebuildPage: rebuildPage,
        ));
      } catch (e) {
        print('Error: $e');
      }
    }

    return;
  }

  _requestObjToMap(RequestOptions request) {
    return {
      'url': request.path,
      'method': request.method,
      'headers': request.headers,
      'data': request.data,
      'queryParameters': request.queryParameters,
    };
  }
}

toFileType(String? fileType) {
  switch (fileType!.toLowerCase()) {
    case 'image':
      return FileType.image;
    case 'video':
      return FileType.video;
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
