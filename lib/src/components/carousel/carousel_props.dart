import 'package:json_annotation/json_annotation.dart';

part 'carousel_props.g.dart';

@JsonSerializable()
class DUICarouselProps {
  final String? height;
  final String? width;
  final String? aspectRatio;
  final String? childHeight;
  final String? childWidth;
  final String? initialPage;
  final String? viewportFraction;
  final bool? autoPlay;
  final String? animationDuration;
  final String? autoPlayInterval;
  final bool? infiniteScroll;
  final bool? enlargeCenterPage;
  final String? enlargeFactor;
  final String? childPadding;
  final bool? reverseScroll;

  DUICarouselProps(
    this.height,
    this.width,
    this.aspectRatio,
    this.childHeight,
    this.childWidth,
    this.initialPage,
    this.viewportFraction,
    this.autoPlay,
    this.animationDuration,
    this.autoPlayInterval,
    this.infiniteScroll,
    this.enlargeCenterPage,
    this.enlargeFactor,
    this.childPadding,
    this.reverseScroll,
  );

  factory DUICarouselProps.fromJson(Map<String, dynamic> json) => _$DUICarouselPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICarouselPropsToJson(this);
}
