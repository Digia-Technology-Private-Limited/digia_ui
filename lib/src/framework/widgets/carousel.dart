import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
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
      return SizedBox(
        height: props.height?.toHeight(payload.buildContext),
        width: props.width?.toWidth(payload.buildContext) ?? double.infinity,
        child: CarouselSlider.builder(
          itemCount: items.length,
          itemBuilder: (context, index, realIndex) {
            return childToRepeat.toWidget(
              payload.copyWithChainedContext(
                _createExprContext(items[index], index),
              ),
            );
          },
          options: CarouselOptions(
            scrollDirection: props.direction,
            aspectRatio: props.aspectRatio,
            autoPlay: props.autoPlay,
            autoPlayAnimationDuration:
                Duration(milliseconds: props.animationDuration),
            autoPlayCurve: Curves.linear,
            autoPlayInterval: Duration(milliseconds: props.autoPlayInterval),
            enableInfiniteScroll: props.infiniteScroll,
            initialPage: props.initialPage,
            viewportFraction: props.viewPortFraction,
            enlargeFactor: props.enlargeFactor,
            enlargeCenterPage: props.enlargeCenterPage,
            reverse: props.reverseScroll,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: props.height?.toHeight(payload.buildContext),
        width: props.width?.toWidth(payload.buildContext) ?? double.infinity,
        child: CarouselSlider.builder(
          itemCount: children?.length,
          itemBuilder: (context, index, realIndex) {
            return children![index].toWidget(payload);
          },
          options: CarouselOptions(
            scrollDirection: props.direction,
            aspectRatio: props.aspectRatio,
            autoPlay: props.autoPlay,
            autoPlayAnimationDuration:
                Duration(milliseconds: props.animationDuration),
            autoPlayCurve: Curves.linear,
            autoPlayInterval: Duration(
              milliseconds: props.autoPlayInterval,
            ),
            enableInfiniteScroll: props.infiniteScroll,
            initialPage: props.initialPage,
            viewportFraction: props.viewPortFraction,
            enlargeFactor: props.enlargeFactor,
            enlargeCenterPage: props.enlargeCenterPage,
            reverse: props.reverseScroll,
          ),
        ),
      );
    }
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}
