import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class ImagePickerAction extends Action {
  final ExprOr<Object>? selectedPageState;

  final String? mediaSource;
  final String? cameraDevice;
  final bool? allowPhoto;
  final bool? allowVideo;
  final ExprOr<double>? maxDuration;

  final ExprOr<double>? maxWidth;
  final ExprOr<double>? maxHeight;

  final ExprOr<double>? imageQuality;

  final ExprOr<double>? limit;

  final bool allowMultiple;

  ImagePickerAction({
    this.mediaSource,
    this.cameraDevice,
    this.allowPhoto = true,
    this.allowVideo = false,
    this.maxDuration,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
    this.limit,
    this.allowMultiple = false,
    this.selectedPageState,
  });

  @override
  ActionType get actionType => ActionType.imagePicker;

  factory ImagePickerAction.fromJson(Map<String, Object?> json) {
    return ImagePickerAction(
      mediaSource: as$<String>(json['mediaSource']),
      cameraDevice: as$<String>(json['cameraDevice']),
      allowPhoto: as$<bool>(json['allowPhoto']),
      allowVideo: as$<bool>(json['allowVideo']),
      allowMultiple: as$<bool>(json['allowMultiple']) ?? false,
      maxWidth: ExprOr.fromJson<double>(json['maxWidth']),
      maxHeight: ExprOr.fromJson<double>(json['maxHeight']),
      imageQuality: ExprOr.fromJson<double>(json['imageQuality']),
      maxDuration: ExprOr.fromJson<double>(json['maxDuration']),
      selectedPageState: ExprOr.fromJson<Object>(json['selectedPageState']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'mediaSource': mediaSource,
      'cameraDevice': cameraDevice,
      'allowPhoto': allowPhoto,
      'allowVideo': allowVideo,
      'allowMultiple': allowMultiple,
      'maxWidth': maxWidth?.toJson(),
      'maxHeight': maxHeight?.toJson(),
      'imageQuality': imageQuality?.toJson(),
      'maxDuration': maxDuration?.toJson(),
      'selectedPageState': selectedPageState?.toJson(),
    };
  }
}
