import '../../../digia_ui.dart';
import '../models/types.dart';
import '../utils/types.dart';

class LottieProps {
  final ExprOr<String>? lottiePath;
  final ExprOr<double>? height;
  final ExprOr<double>? width;
  final ExprOr<String>? alignment;
  final ExprOr<String>? fit;
  final ExprOr<bool>? animate;
  final String? animationType;
  final ExprOr<double>? frameRate;
  final ActionFlow? onComplete;

  const LottieProps({
    this.lottiePath,
    this.height,
    this.width,
    this.alignment,
    this.fit,
    this.animate,
    this.animationType,
    this.frameRate,
    this.onComplete,
  });

  factory LottieProps.fromJson(JsonLike json) {
    final src = json['src'];
    final srcPath = src is JsonLike ? src['lottiePath'] : src;
    return LottieProps(
      lottiePath: ExprOr.fromJson<String>(
        srcPath ?? json['lottiePath'],
      ),
      height: ExprOr.fromJson<double>(json['height']),
      width: ExprOr.fromJson<double>(json['width']),
      alignment: ExprOr.fromJson<String>(json['alignment']),
      fit: ExprOr.fromJson<String>(json['fit']),
      animate: ExprOr.fromJson<bool>(json['animate']),
      animationType: json['animationType'] as String?,
      frameRate: ExprOr.fromJson<double>(json['frameRate']),
      onComplete: ActionFlow.fromJson(json['onComplete']),
    );
  }
}
