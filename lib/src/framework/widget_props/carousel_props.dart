import 'package:flutter/widgets.dart';
import '../internal_widgets/internal_carousel.dart';
import '../models/types.dart';
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
  final double viewportFraction;
  final bool autoPlay;
  final int animationDuration;
  final int autoPlayInterval;
  final bool infiniteScroll;
  final bool reverseScroll;
  final double enlargeFactor;
  final bool showIndicator;
  final double offset;
  final double dotHeight;
  final double dotWidth;
  final bool padEnds;
  final double spacing;
  final bool pageSnapping;
  final ExprOr<String>? dotColor;
  final ExprOr<String>? activeDotColor;
  final String indicatorEffectType;
  final bool? keepAlive;

  const CarouselProps({
    this.width,
    this.height,
    this.direction = Axis.horizontal,
    this.aspectRatio = 0.25,
    this.initialPage = 1,
    this.enlargeCenterPage = false,
    this.viewportFraction = 0.8,
    this.autoPlay = false,
    this.animationDuration = 800,
    this.autoPlayInterval = 1600,
    this.infiniteScroll = false,
    this.pageSnapping = true,
    this.padEnds = true,
    this.reverseScroll = false,
    this.enlargeFactor = 0.3,
    this.showIndicator = false,
    this.offset = 16.0,
    this.dotHeight = 8.0,
    this.dotWidth = 8.0,
    this.spacing = 16.0,
    this.dotColor,
    this.activeDotColor,
    this.indicatorEffectType = 'slide',
    this.keepAlive = false,
  });

  /// Factory constructor to create an instance from JSON
  factory CarouselProps.fromJson(JsonLike json) {
    final indicatorJson =
        (json['indicator'] as Map?)?['indicatorAvailable'] ?? {};
    return CarouselProps(
        width: as$<String>(json['width']),
        height: as$<String>(json['height']),
        direction: To.axis(as$<String>(json['direction'])) ?? Axis.horizontal,
        aspectRatio: as$<double>(json['aspectRatio']) ?? 0.25,
        initialPage: as$<int>(json['initialPage']) ?? 1,
        enlargeCenterPage: as$<bool>(json['enlargeCenterPage']) ?? false,
        viewportFraction: as$<double>(json['viewportFraction']) ?? 0.8,
        autoPlay: as$<bool>(json['autoPlay']) ?? false,
        animationDuration: as$<int>(json['animationDuration']) ?? 800,
        autoPlayInterval: as$<int>(json['autoPlayInterval']) ?? 1600,
        infiniteScroll: as$<bool>(json['infiniteScroll']) ?? false,
        reverseScroll: as$<bool>(json['reverseScroll']) ?? false,
        pageSnapping: as$<bool>(json['pageSnapping']) ?? true,
        padEnds: as$<bool>(json['padEnds']) ?? true,
        enlargeFactor: as$<double>(json['enlargeFactor']) ?? 0.3,
        showIndicator: as$<bool>(indicatorJson['showIndicator']) ?? false,
        offset: as$<double>(indicatorJson['offset']) ?? 16.0,
        dotHeight: as$<double>(indicatorJson['dotHeight']) ?? 8.0,
        dotWidth: as$<double>(indicatorJson['dotWidth']) ?? 8.0,
        spacing: as$<double>(indicatorJson['spacing']) ?? 16.0,
        dotColor: ExprOr.fromJson<String>(indicatorJson['dotColor']),
        keepAlive: as$<bool>(json['keepAlive']) ?? false,
        activeDotColor:
            ExprOr.fromJson<String>(indicatorJson['activeDotColor']),
        indicatorEffectType:
            as$<String>(indicatorJson['indicatorEffectType']) ??
                IndicatorEffectType.slide.value);
  }
}
