import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class ImagePickerAction extends Action {
  final ExprOr<Object>? fileVariable;

  final String? mediaSource;
  final String? cameraDevice;
  final String? mediaType;
  final ExprOr<double>? maxDuration;

  final ExprOr<double>? maxWidth;
  final ExprOr<double>? maxHeight;

  final ExprOr<double>? imageQuality;

  final ExprOr<double>? limit;

  final bool allowMultiple;

  ImagePickerAction({
    this.mediaSource,
    this.cameraDevice,
    this.mediaType,
    this.maxDuration,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.limit,
    this.allowMultiple = false,
    this.fileVariable,
  });

  @override
  ActionType get actionType => ActionType.imagePicker;

  factory ImagePickerAction.fromJson(Map<String, Object?> json) {
    return ImagePickerAction(
      mediaSource: as$<String>(json['mediaSource']),
      cameraDevice: as$<String>(json['cameraDevice']),
      mediaType: as$<String>(json['mediaType']),
      allowMultiple: as$<bool>(json['allowMultiple']) ?? false,
      maxWidth: ExprOr.fromJson<double>(json['maxWidth']),
      maxHeight: ExprOr.fromJson<double>(json['maxHeight']),
      imageQuality: ExprOr.fromJson<double>(json['imageQuality']),
      maxDuration: ExprOr.fromJson<double>(json['maxDuration']),
      fileVariable: ExprOr.fromJson<Object>(json['fileVariable']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'mediaSource': mediaSource,
      'cameraDevice': cameraDevice,
      'mediaType': mediaType,
      'allowMultiple': allowMultiple,
      'maxWidth': maxWidth?.toJson(),
      'maxHeight': maxHeight?.toJson(),
      'imageQuality': imageQuality?.toJson(),
      'maxDuration': maxDuration?.toJson(),
      'fileVariable': fileVariable?.toJson(),
    };
  }
}
