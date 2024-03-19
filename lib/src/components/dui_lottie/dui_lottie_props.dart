import 'package:json_annotation/json_annotation.dart';

part 'dui_lottie_props.g.dart';

@JsonSerializable()
class DUILottieProps {
  final String? lottiePath;
  final String? fit;
  final String? alignment;
  final double? height;
  final double? width;
  final double? frameRate;
  final bool? reverse;
  final bool? animate;
  final bool? repeat;

  DUILottieProps({
    this.lottiePath,
    this.fit,
    this.alignment,
    this.height,
    this.width,
    this.frameRate,
    this.reverse,
    this.animate,
    this.repeat,
  });

  factory DUILottieProps.fromJson(Map<String, dynamic> json) =>
      _$DUILottiePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUILottiePropsToJson(this);
}
