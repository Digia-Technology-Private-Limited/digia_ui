import 'package:flutter/widgets.dart';

import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class CarouselProps {
  final String? width;
  final String? height;
  final Axis direction;
  final double aspectRatio;
  final int initialPage;
  final bool enlargeCenterPage;
  final double viewPortFraction;
  final bool autoPlay;
  final int animationDuration;
  final int autoPlayInterval;
  final bool infiniteScroll;
  final bool reverseScroll;
  final double enlargeFactor;

  CarouselProps({
    this.width,
    this.height,
    this.direction = Axis.horizontal, // Default value for `direction`
    this.aspectRatio = 1.78,
    this.initialPage = 1,
    this.enlargeCenterPage = false, // Default value for `enlargeCenterPage`
    this.viewPortFraction = 0.8,
    this.autoPlay = false,
    this.animationDuration = 800,
    this.autoPlayInterval = 1600,
    this.infiniteScroll = false,
    this.reverseScroll = false,
    this.enlargeFactor = 0.3,
  });

  /// Factory constructor to create an instance from JSON
  factory CarouselProps.fromJson(JsonLike json) {
    return CarouselProps(
      width: as$<String>(json['width']),
      height: as$<String>(json['height']),
      direction: To.axis(as$<String>(json['direction'])) ?? Axis.horizontal,
      aspectRatio: as$<double>(json['aspectRatio']) ?? 1.78,
      initialPage: as$<int>(json['initialPage']) ?? 1,
      enlargeCenterPage: as$<bool>(json['enlargeCenterPage']) ?? false,
      viewPortFraction: as$<double>(json['viewPortFraction']) ?? 0.8,
      autoPlay: as$<bool>(json['autoPlay']) ?? false,
      animationDuration: as$<int>(json['animationDuration']) ?? 800,
      autoPlayInterval: as$<int>(json['autoPlayInterval']) ?? 1600,
      infiniteScroll: as$<bool>(json['infiniteScroll']) ?? false,
      reverseScroll: as$<bool>(json['reverseScroll']) ?? false,
      enlargeFactor: as$<double>(json['enlargeFactor']) ?? 0.3,
    );
  }
}
