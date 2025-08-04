import 'package:flutter/material.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_carousel.dart';
import '../render_payload.dart';
import '../utils/flutter_extensions.dart';
import '../utils/functional_util.dart';
import '../widget_props/carousel_props.dart';

class VWCarousel extends VirtualStatelessWidget<CarouselProps> {
  VWCarousel({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.dataSource != null;

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(
              props.dataSource?.evaluate(payload.scopeContext)) ??
          [];
      return InternalCarousel(
        itemCount: items.length,
        itemBuilder: (buildContext, index) => child!.toWidget(
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
        initialPage: payload.evalExpr(props.initialPage) ?? 0,
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
        indicatorEffectType: props.indicatorEffectType,
        keepAlive: props.keepAlive,
        onChanged: (value) async {
          await payload.executeAction(
            props.onChanged,
            scopeContext: _createExprContextForAction(value),
          );
        },
      );
    }
    return InternalCarousel(
      width: props.width?.toWidth(payload.buildContext) ?? double.infinity,
      height: props.height?.toHeight(payload.buildContext),
      direction: props.direction,
      aspectRatio: props.aspectRatio,
      autoPlay: props.autoPlay,
      animationDuration: props.animationDuration,
      autoPlayInterval: props.autoPlayInterval,
      infiniteScroll: props.infiniteScroll,
      pageSnapping: props.pageSnapping,
      initialPage: payload.evalExpr(props.initialPage) ?? 0,
      padEnds: props.padEnds,
      viewportFraction: props.viewportFraction,
      enlargeFactor: props.enlargeFactor,
      enlargeCenterPage: props.enlargeCenterPage,
      reverseScroll: props.reverseScroll,
      offset: props.offset,
      dotHeight: props.dotHeight,
      dotWidth: props.dotWidth,
      spacing: props.spacing,
      showIndicator: props.showIndicator,
      keepAlive: props.keepAlive,
      dotColor: payload.evalColorExpr(props.dotColor) ?? Colors.grey,
      activeDotColor:
          payload.evalColorExpr(props.activeDotColor) ?? Colors.indigo,
      indicatorEffectType: props.indicatorEffectType,
      children: [child?.toWidget(payload) ?? empty()],
      onChanged: (value) async {
        await payload.executeAction(
          props.onChanged,
          scopeContext: _createExprContextForAction(value),
        );
      },
    );
  }

  ScopeContext _createExprContextForAction(int index) {
    return DefaultScopeContext(variables: {'index': index});
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final carouselObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...carouselObj,
      ...?refName.maybe((it) => {it: carouselObj}),
    });
  }
}
