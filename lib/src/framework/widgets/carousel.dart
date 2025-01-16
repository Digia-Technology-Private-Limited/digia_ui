import 'package:flutter/material.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_carousel.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../widget_props/carousel_props.dart';

class VWCarousel extends VirtualStatelessWidget<CarouselProps> {
  VWCarousel({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });
  bool get shouldRepeatChild => repeatData != null;

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();

    if (shouldRepeatChild) {
      final childToRepeat = children!.first;
      final items = payload.evalRepeatData(repeatData!);
      return InternalCarousel(
        itemCount: items.length,
        itemBuilder: (buildContext, index) => childToRepeat.toWidget(
          payload.copyWithChainedContext(
            _createExprContext(items[index], index),
          ),
        ),
        width: props.width?.toWidth(payload.buildContext) ?? double.infinity,
        height: props.height?.toHeight(payload.buildContext),
        direction: props.direction,
        aspectRatio: props.aspectRatio,
        autoPlay: props.autoPlay,
        showIndicator: props.showIndicator,
        animationDuration: props.animationDuration,
        autoPlayInterval: props.autoPlayInterval,
        infiniteScroll: props.infiniteScroll,
        initialPage: props.initialPage,
        pageSnapping: props.pageSnapping,
        viewportFraction: props.viewportFraction,
        enlargeFactor: props.enlargeFactor,
        enlargeCenterPage: props.enlargeCenterPage,
        reverseScroll: props.reverseScroll,
        offset: props.offset,
        padEnds: props.padEnds,
        dotHeight: props.dotHeight,
        dotWidth: props.dotWidth,
        spacing: props.spacing,
        dotColor: payload.evalColorExpr(props.dotColor) ?? Colors.grey,
        activeDotColor:
            payload.evalColorExpr(props.activeDotColor) ?? Colors.indigo,
      );
    }
    return InternalCarousel(
      children: children?.toWidgetArray(payload) ?? [],
      width: props.width?.toWidth(payload.buildContext) ?? double.infinity,
      height: props.height?.toHeight(payload.buildContext),
      direction: props.direction,
      aspectRatio: props.aspectRatio,
      autoPlay: props.autoPlay,
      animationDuration: props.animationDuration,
      autoPlayInterval: props.autoPlayInterval,
      infiniteScroll: props.infiniteScroll,
      pageSnapping: props.pageSnapping,
      initialPage: props.initialPage,
      padEnds: props.padEnds,
      viewportFraction: props.viewportFraction,
      enlargeFactor: props.enlargeFactor,
      enlargeCenterPage: props.enlargeCenterPage,
      reverseScroll: props.reverseScroll,
      offset: props.offset,
      dotHeight: props.dotHeight,
      dotWidth: props.dotWidth,
      spacing: props.spacing,
      dotColor: payload.evalColorExpr(props.dotColor) ?? Colors.grey,
      activeDotColor:
          payload.evalColorExpr(props.activeDotColor) ?? Colors.indigo,
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}

extension on List<VirtualWidget>? {
  toWidgetArray(RenderPayload payload) {}
}
