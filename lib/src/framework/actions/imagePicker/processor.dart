import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data_type/adapted_types/file.dart';
import '../../expr/scope_context.dart';
import '../../utils/functional_util.dart';
import '../base/processor.dart';
import 'action.dart';

class ImagePickerProcessor extends ActionProcessor<ImagePickerAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ImagePickerAction action,
    ScopeContext? scopeContext,
  ) async {
    final mediaSource = action.mediaSource;
    final cameraDevice = action.cameraDevice;
    final allowPhoto = action.allowPhoto ?? true;
    final allowVideo = action.allowVideo ?? false;
    final maxDuration = action.maxDuration?.evaluate(scopeContext);
    final maxWidth = action.maxWidth?.evaluate(scopeContext);
    final maxHeight = action.maxHeight?.evaluate(scopeContext);
    final imageQuality = action.imageQuality?.evaluate(scopeContext)?.round();
    final limit = action.limit?.evaluate(scopeContext)?.round();
    final allowMultiple = action.allowMultiple ?? false;
    final selectedPageState =
        action.selectedPageState?.evaluate(scopeContext) as AdaptedFile?;

    if (!allowPhoto && !allowVideo) {
      throw 'At least one of allowPhoto or allowVideo must be true';
    }

    ImageSource source = _toImageSource(mediaSource) ?? ImageSource.gallery;
    CameraDevice device = _toCameraDevice(cameraDevice) ?? CameraDevice.rear;

    final imagePicker = ImagePicker();
    List<XFile> pickedFiles = [];

    try {
      if (allowMultiple) {
        if (allowPhoto && allowVideo) {
          pickedFiles = await imagePicker.pickMultipleMedia(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            limit: limit,
            requestFullMetadata: false,
          );
        } else if (allowPhoto) {
          pickedFiles = await imagePicker.pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            limit: limit,
            requestFullMetadata: false,
          );
        } else if (allowVideo) {
          pickedFiles = await imagePicker.pickMultipleMedia(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            limit: limit,
            requestFullMetadata: false,
          );
        }
      } else {
        XFile? pickedFile;
        if (allowPhoto && allowVideo) {
          pickedFile = await imagePicker.pickMedia(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            requestFullMetadata: false,
          );
        } else if (allowPhoto) {
          pickedFile = await imagePicker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
            preferredCameraDevice: device,
            requestFullMetadata: false,
          );
        } else if (allowVideo) {
          pickedFile = await imagePicker.pickVideo(
              source: source,
              preferredCameraDevice: device,
              maxDuration:
                  maxDuration.maybe((e) => Duration(seconds: e.round())));
        }
        if (pickedFile != null) pickedFiles = [pickedFile];
      }

      if (pickedFiles.isEmpty) {
        // User canceled the picker
        return null;
      }
      // logger?.log(ActionLog(getPageName(context), 'Action.imagePicker', {
      //   'mediaSource': mediaSource,
      //   'cameraDevice': cameraDevice,
      //   'allowPhoto': allowPhoto,
      //   'allowVideo': allowVideo,
      //   'maxDuration': maxDuration,
      //   'maxWidth': maxWidth,
      //   'maxHeight': maxHeight,
      //   'imageQuality': imageQuality,
      //   'limit': limit,
      //   'allowMultiple': allowMultiple,
      //   'selectedPageState': selectedPageState,
      //   'rebuildPage': rebuildPage,
      //   'fileCount': pickedFiles.length,
      // }));
    } catch (e) {
      print('Error picking media: $e');
      return null;
    }

    if (pickedFiles.isNotEmpty) {
      try {
        if (pickedFiles.isNotEmpty) {
          List<AdaptedFile> finalFiles = await getFinalFiles(pickedFiles);

          if (selectedPageState != null) {
            selectedPageState.setDataFromAdaptedFile(finalFiles.first);
          }
        }
      } catch (e) {
        print('Error processing picked media: $e');
      }
    }

    return null;
  }
}

Future<List<AdaptedFile>> getFinalFiles(List<XFile> pickedFiles) async {
  List<AdaptedFile> finalFiles = await Future.wait(
    pickedFiles.map((xFile) async {
      final file = AdaptedFile.fromXFile(xFile);
      if (file.isWeb) {
        file.bytes = await xFile.readAsBytes(); // Read the bytes for web
        file.size = file.bytes?.lengthInBytes; // Set the size for web
      } else if (file.isMobile) {
        final fileStat = await File(xFile.path).stat();
        file.size = fileStat.size; // Set the size for mobile
      }
      return file;
    }).toList(),
  );
  return finalFiles;
}

ImageSource? _toImageSource(dynamic mediaSource) =>
    switch (mediaSource?.toLowerCase()) {
      'camera' => ImageSource.camera,
      'gallery' => ImageSource.gallery,
      _ => null,
    };

CameraDevice? _toCameraDevice(dynamic cameraDevice) =>
    switch (cameraDevice?.toLowerCase()) {
      'front' => CameraDevice.front,
      'rear' => CameraDevice.rear,
      _ => null,
    };
