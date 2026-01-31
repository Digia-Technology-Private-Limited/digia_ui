import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class ScratchCardProps {
  final String? height;
  final String? width;
  final ExprOr<double>? brushSize;
  final ExprOr<double>? revealFullAtPercent;
  final ExprOr<bool>? isScratchingEnabled;
  final ExprOr<int>? gridResolution;
  final ExprOr<bool>? enableTapToScratch;
  final ExprOr<String>? brushColor;
  final ExprOr<double>? brushOpacity;
  final ExprOr<String>? brushShape;
  final ExprOr<bool>? enableHapticFeedback;
  final ExprOr<String>? revealAnimationType;
  final ExprOr<int>? animationDurationMs;
  final ExprOr<bool>? enableProgressAnimation;
  final ActionFlow? onScratchComplete;

  const ScratchCardProps({
    this.height,
    this.width,
    this.brushSize,
    this.revealFullAtPercent,
    this.isScratchingEnabled,
    this.gridResolution,
    this.enableTapToScratch,
    this.brushColor,
    this.brushOpacity,
    this.brushShape,
    this.enableHapticFeedback,
    this.revealAnimationType,
    this.animationDurationMs,
    this.enableProgressAnimation,
    this.onScratchComplete,
  });

  static ScratchCardProps fromJson(JsonLike json) {
    return ScratchCardProps(
      height: as$<String>(json['height']),
      width: as$<String>(json['width']),
      brushSize: ExprOr.fromJson<double>(json['brushSize']),
      revealFullAtPercent: ExprOr.fromJson<double>(json['revealFullAtPercent']),
      isScratchingEnabled: ExprOr.fromJson<bool>(json['isScratchingEnabled']),
      gridResolution: ExprOr.fromJson<int>(json['gridResolution']),
      enableTapToScratch: ExprOr.fromJson<bool>(json['enableTapToScratch']),
      brushColor: ExprOr.fromJson<String>(json['brushColor']),
      brushOpacity: ExprOr.fromJson<double>(json['brushOpacity']),
      brushShape: ExprOr.fromJson<String>(json['brushShape']),
      enableHapticFeedback: ExprOr.fromJson<bool>(json['enableHapticFeedback']),
      revealAnimationType: ExprOr.fromJson<String>(json['revealAnimationType']),
      animationDurationMs: ExprOr.fromJson<int>(json['animationDurationMs']),
      enableProgressAnimation:
          ExprOr.fromJson<bool>(json['enableProgressAnimation']),
      onScratchComplete: ActionFlow.fromJson(json['onScratchComplete']),
    );
  }
}
