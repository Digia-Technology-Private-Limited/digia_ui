import 'package:carousel_slider/carousel_slider.dart';
import 'package:digia_ui/components/carousel/carousel_props.dart';

import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';

class DUICarousel extends StatelessWidget {
  const DUICarousel(this.props, this.data, {super.key, required this.registry});
  final DUICarouselProps props;
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;

  @override
  Widget build(BuildContext context) {
    final height = _toWidth(context, props.height);
    final width = _toWidth(context, props.width) ?? double.infinity;
    final padding = double.tryParse(props.childPadding ?? '0') ?? 0;
    // final borderRadius = DUIDecoder.toBorderRadius(props.borderRadius);

    return Container(
      height: height,
      width: width,
      child: CarouselSlider(
        items: data.children['children']!.map((e) {
          final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
          return Container(
              height: _toHeight(context, props.childHeight),
              width: _toWidth(context, props.childWidth),
              padding: EdgeInsets.symmetric(horizontal: padding),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      double.tryParse(props.borderRadius ?? '8') ?? 8)),
              child: builder.build(context));
        }).toList(),
        options: CarouselOptions(
            aspectRatio: double.tryParse(props.aspectRatio ?? '0.25') ?? 0.25,
            autoPlay: props.autoPlay ?? false,
            autoPlayAnimationDuration: Duration(
                milliseconds:
                    int.tryParse(props.animationDuration ?? '800') ?? 800),
            autoPlayCurve: Curves.linear,
            autoPlayInterval: Duration(
                milliseconds:
                    int.tryParse(props.autoPlayInterval ?? '3000') ?? 3000),
            enableInfiniteScroll: props.infiniteScroll ?? false,
            initialPage: int.tryParse(props.initialPage ?? '1') ?? 1,
            viewportFraction:
                double.tryParse(props.viewportFraction ?? '0.5') ?? 0.5,
            enlargeFactor:
                double.tryParse(props.enlargeFactor ?? '0.25') ?? 0.25,
            enlargeCenterPage: props.enlargeCenterPage),
      ),
    );
  }

  double? _toHeight(BuildContext context, String? extentStringValue) {
    if (extentStringValue == null || extentStringValue.isEmpty == true) {
      return null;
    }

    final parsedValue = double.tryParse(extentStringValue);
    if (parsedValue != null) return parsedValue;

    if (extentStringValue.characters.last == '%') {
      final substring =
          extentStringValue.substring(0, extentStringValue.length - 1);
      final factor = double.tryParse(substring);
      if (factor == null) return null;

      return MediaQuery.of(context).size.height * (factor / 100);
    }

    return null;
  }

  double? _toWidth(BuildContext context, String? extentStringValue) {
    if (extentStringValue == null || extentStringValue.isEmpty == true) {
      return null;
    }

    final parsedValue = double.tryParse(extentStringValue);
    if (parsedValue != null) return parsedValue;

    if (extentStringValue.characters.last == '%') {
      final substring =
          extentStringValue.substring(0, extentStringValue.length - 1);
      final factor = double.tryParse(substring);
      if (factor == null) return null;

      return MediaQuery.of(context).size.width * (factor / 100);
    }

    return null;
  }
}
