import 'package:carousel_slider/carousel_slider.dart';
import 'package:digia_ui/src/components/carousel/carousel_props.dart';
import 'package:digia_ui/src/Utils/dui_widget_registry.dart';
import 'package:digia_ui/src/core/builders/dui_json_widget_builder.dart';
import 'package:digia_ui/src/core/page/props/dui_widget_json_data.dart';
import 'package:flutter/material.dart';
import '../../Utils/extensions.dart';

class DUICarousel extends StatelessWidget {
  const DUICarousel(this.props, this.data, {super.key, required this.registry});
  final DUICarouselProps props;
  final DUIWidgetJsonData data;
  final DUIWidgetRegistry? registry;

  @override
  Widget build(BuildContext context) {
    final height = props.height?.toHeight(context);
    final width = props.width?.toWidth(context) ?? double.infinity;
    final padding = double.tryParse(props.childPadding ?? '0') ?? 0;
    // final borderRadius = DUIDecoder.toBorderRadius(props.borderRadius);

    return SizedBox(
      height: height,
      width: width,
      child: CarouselSlider(
        items: data.children['children']!.map((e) {
          final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
          return Container(
              height: props.childHeight?.toHeight(context),
              width: props.childWidth?.toWidth(context),
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
}
