import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'keep_alive_widget.dart';

class InternalCarousel extends StatefulWidget {
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;
  final int itemCount;
  final double? width;
  final double? height;
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
  final bool padEnds;
  final double dotWidth;
  final bool pageSnapping;
  final double spacing;
  final Color? dotColor;
  final String indicatorEffectType;
  final Color? activeDotColor;
  final bool? keepAlive;
  final ValueChanged<int>? onChanged;
  const InternalCarousel(
      {super.key,
      this.itemBuilder,
      this.children = const [],
      this.width,
      this.itemCount = 0,
      this.height,
      this.direction = Axis.horizontal,
      this.aspectRatio = 0.25,
      this.keepAlive = false,
      this.initialPage = 0,
      this.enlargeCenterPage = false,
      this.viewportFraction = 0.8,
      this.autoPlay = false,
      this.padEnds = true,
      this.animationDuration = 800,
      this.autoPlayInterval = 1600,
      this.infiniteScroll = false,
      this.reverseScroll = false,
      this.enlargeFactor = 0.3,
      this.showIndicator = false,
      this.offset = 16.0,
      this.dotHeight = 8.0,
      this.dotWidth = 8.0,
      this.spacing = 16.0,
      this.pageSnapping = true,
      this.dotColor,
      this.activeDotColor,
      this.onChanged,
      this.indicatorEffectType = 'slide'});

  @override
  State<InternalCarousel> createState() => _InternalCarouselState();
}

class _InternalCarouselState extends State<InternalCarousel> {
  late ValueNotifier<int> _currentPageNotifier;
  late CarouselSliderController _carouselController;

  @override
  void initState() {
    super.initState();
    _currentPageNotifier = ValueNotifier<int>(widget.initialPage);
    _carouselController = CarouselSliderController();
  }

  @override
  void dispose() {
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (widget.itemBuilder != null) {
      child = SizedBox(
        height: widget.height,
        width: widget.width,
        child: CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.itemCount,
          itemBuilder: (ctx, index, realIndex) {
            return KeepAliveWrapper(
                keepTabsAlive: widget.keepAlive,
                child: widget.itemBuilder!.call(ctx, index));
          },
          options: CarouselOptions(
            scrollDirection: widget.direction,
            aspectRatio: widget.aspectRatio,
            // disableCenter: true,
            padEnds: widget.padEnds,
            autoPlay: widget.autoPlay,
            pageSnapping: widget.pageSnapping,
            autoPlayAnimationDuration:
                Duration(milliseconds: widget.animationDuration),
            autoPlayCurve: Curves.linear,
            autoPlayInterval: Duration(milliseconds: widget.autoPlayInterval),
            enableInfiniteScroll: widget.infiniteScroll,
            initialPage: widget.initialPage,
            viewportFraction: widget.viewportFraction,
            enlargeFactor: widget.enlargeFactor,
            enlargeCenterPage: widget.enlargeCenterPage,
            reverse: widget.reverseScroll,
            onPageChanged: (index, reason) {
              _currentPageNotifier.value = index;
              widget.onChanged?.call(index);
            },
          ),
        ),
      );
    } else {
      child = SizedBox(
        height: widget.height,
        width: widget.width,
        child: CarouselSlider.builder(
          itemCount: widget.children.length,
          carouselController: _carouselController,
          itemBuilder: (context, index, realIndex) {
            return KeepAliveWrapper(
                keepTabsAlive: widget.keepAlive, child: widget.children[index]);
          },
          options: CarouselOptions(
            scrollDirection: widget.direction,
            aspectRatio: widget.aspectRatio,
            padEnds: widget.padEnds,
            autoPlay: widget.autoPlay,
            // disableCenter: true,
            pageSnapping: widget.pageSnapping,
            autoPlayAnimationDuration:
                Duration(milliseconds: widget.animationDuration),
            autoPlayCurve: Curves.linear,
            autoPlayInterval: Duration(
              milliseconds: widget.autoPlayInterval,
            ),
            enableInfiniteScroll: widget.infiniteScroll,
            initialPage: widget.initialPage,
            viewportFraction: widget.viewportFraction,
            enlargeFactor: widget.enlargeFactor,
            enlargeCenterPage: widget.enlargeCenterPage,
            reverse: widget.reverseScroll,
            onPageChanged: (index, reason) {
              _currentPageNotifier.value = index;
              widget.onChanged?.call(index);
            },
          ),
        ),
      );
    }
    if (!widget.showIndicator) {
      return child;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, value, _) {
              return IndicatorBuilder(
                indicatorEffect: widget.indicatorEffectType,
                currentPageNotifier: _currentPageNotifier,
                itemCount: widget.itemBuilder != null
                    ? widget.itemCount
                    : widget.children.length,
                carouselController: _carouselController,
                offset: widget.offset,
                dotHeight: widget.dotHeight,
                dotWidth: widget.dotWidth,
                spacing: widget.spacing,
                dotColor: widget.dotColor,
                activeDotColor: widget.activeDotColor,
              );
            },
          ),
        ),
      ],
    );
  }
}

class IndicatorBuilder extends StatelessWidget {
  final ValueNotifier<int> currentPageNotifier;
  final int itemCount;
  final CarouselSliderController carouselController;
  final double offset;
  final double dotHeight;
  final double dotWidth;
  final double spacing;
  final Color? dotColor;
  final Color? activeDotColor;
  final String indicatorEffect;

  const IndicatorBuilder(
      {super.key,
      required this.currentPageNotifier,
      required this.itemCount,
      required this.carouselController,
      required this.offset,
      required this.dotHeight,
      required this.dotWidth,
      required this.spacing,
      this.dotColor,
      this.activeDotColor,
      required this.indicatorEffect});

  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: currentPageNotifier.value,
      count: itemCount,
      onDotClicked: (index) {
        carouselController.animateToPage(index);
      },
      effect: _getIndicatorEffect(
          indicatorEffect: IndicatorEffectType.values.firstWhere(
        (element) => element.value == indicatorEffect,
      )),
    );
  }

  IndicatorEffect _getIndicatorEffect(
      {required IndicatorEffectType indicatorEffect}) {
    switch (indicatorEffect) {
      case IndicatorEffectType.scrolling:
        return ScrollingDotsEffect(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
      case IndicatorEffectType.worm:
        return WormEffect(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
      case IndicatorEffectType.jumping:
        return JumpingDotEffect(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
      case IndicatorEffectType.scale:
        return ScaleEffect(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
      case IndicatorEffectType.expanding:
        return ExpandingDotsEffect(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
      case IndicatorEffectType.swap:
        return SwapEffect(
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
      case IndicatorEffectType.circleAroundDot:
        return CustomizableEffect(
          spacing: spacing,
          dotDecoration: DotDecoration(
            borderRadius: BorderRadius.circular(100),
            width: dotWidth,
            height: dotHeight,
            color: dotColor ?? Colors.grey,
          ),
          activeDotDecoration: DotDecoration(
            borderRadius: BorderRadius.circular(100),
            width: dotWidth,
            height: dotHeight,
            color: activeDotColor ?? Colors.indigo,
            dotBorder: DotBorder(
                padding: dotHeight * 0.75,
                color: activeDotColor ?? Colors.indigo,
                width: 2,
                type: DotBorderType.solid),
          ),
        );
      case IndicatorEffectType.slide:
        return SlideEffect(
          offset: offset,
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          spacing: spacing,
          dotColor: dotColor ?? Colors.grey,
          activeDotColor: activeDotColor ?? Colors.indigo,
        );
    }
  }
}

enum IndicatorEffectType {
  worm('worm'),
  slide('slide'),
  swap('swap'),
  expanding('expanding'),
  scale('scale'),
  jumping('jumping'),
  scrolling('scrolling'),
  circleAroundDot('circleAroundDot');

  final String value;

  const IndicatorEffectType(this.value);
}
