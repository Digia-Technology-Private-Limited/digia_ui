import 'dart:io';

import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/logger.dart';
import '../../data_type/adapted_types/file.dart';
import '../../expr/scope_context.dart';
import '../../utils/functional_util.dart';
import '../action_descriptor.dart';
import '../base/processor.dart';
import 'action.dart';

class ImagePickerProcessor extends ActionProcessor<ImagePickerAction> {
  @override
  Future<Object?>? execute(
    BuildContext context,
    ImagePickerAction action,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) async {
    final mediaSource = action.mediaSource;
    final cameraDevice = action.cameraDevice;
    final allowPhoto = action.mediaType == 'photo' || action.mediaType == 'all';
    final allowVideo = action.mediaType == 'video' || action.mediaType == 'all';
    final maxDuration = action.maxDuration?.evaluate(scopeContext);
    final maxWidth = action.maxWidth?.evaluate(scopeContext);
    final maxHeight = action.maxHeight?.evaluate(scopeContext);
    final imageQuality = action.imageQuality?.evaluate(scopeContext)?.round();
    final limit = action.limit?.evaluate(scopeContext)?.round();
    final allowMultiple = action.allowMultiple;
    final selectedPageState =
        action.fileVariable?.evaluate(scopeContext) as AdaptedFile?;

    final desc = ActionDescriptor(
      id: id,
      type: action.actionType,
      definition: action.toJson(),
      resolvedParameters: {
        'mediaSource': mediaSource,
        'cameraDevice': cameraDevice,
        'allowPhoto': allowPhoto,
        'allowVideo': allowVideo,
        'maxDuration': maxDuration,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
        'imageQuality': imageQuality,
        'limit': limit,
        'allowMultiple': allowMultiple,
      },
    );

    executionContext?.notifyStart(
      id: id,
      parentActionId: parentActionId,
      descriptor: desc,
      observabilityContext: observabilityContext,
    );

    if (!allowPhoto && !allowVideo) {
      final error = 'At least one of allowPhoto or allowVideo must be true';
      executionContext?.notifyComplete(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        error: error,
        stackTrace: StackTrace.current,
        observabilityContext: observabilityContext,
      );
      throw error;
    }

    ImageSource source = _toImageSource(mediaSource) ?? ImageSource.gallery;
    CameraDevice device = _toCameraDevice(cameraDevice) ?? CameraDevice.rear;

    final imagePicker = ImagePicker();
    List<XFile> pickedFiles = [];

    try {
      executionContext?.notifyProgress(
        id: id,
        parentActionId: parentActionId,
        descriptor: desc,
        details: {
          'stage': 'image_picker_started',
          'mediaSource': mediaSource,
          'cameraDevice': cameraDevice,
          'allowPhoto': allowPhoto,
          'allowVideo': allowVideo,
          'allowMultiple': allowMultiple,
        },
        observabilityContext: observabilityContext,
      );

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
          if (source == ImageSource.camera) {
            // Default to photo capture when both are allowed and source is camera.
            pickedFile = await imagePicker.pickImage(
              source: source,
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: imageQuality,
              preferredCameraDevice: device,
              requestFullMetadata: false,
            );
          } else {
            pickedFile = await imagePicker.pickMedia(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              imageQuality: imageQuality,
              requestFullMetadata: false,
            );
          }
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
          'stage': 'media_picked',
          'fileCount': pickedFiles.length,
          'fileNames': pickedFiles.map((f) => f.name).toList(),
        },
        observabilityContext: observabilityContext,
      );
    } catch (e) {
      Logger.error('Error picking media: $e',
          tag: 'ImagePickerProcessor', error: e);
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

    if (pickedFiles.isNotEmpty) {
      try {
        if (pickedFiles.isNotEmpty) {
          List<AdaptedFile> finalFiles = await getFinalFiles(pickedFiles);

          if (selectedPageState != null) {
            selectedPageState.setDataFromAdaptedFile(finalFiles.first);
          }

          executionContext?.notifyProgress(
            id: id,
            parentActionId: parentActionId,
            descriptor: desc,
            details: {
              'stage': 'media_processed',
              'finalFileCount': finalFiles.length,
              'fileSet': selectedPageState != null,
            },
            observabilityContext: observabilityContext,
          );
        }
      } catch (e) {
        Logger.error('Error processing picked media: $e',
            tag: 'ImagePickerProcessor', error: e);
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
