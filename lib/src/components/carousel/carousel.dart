import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/common.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/page/props/dui_widget_json_data.dart';
import 'carousel_props.dart';

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
    final children = data.children['children'] ?? [];

    if (children.isEmpty) return _emptyChildWidget();

    List items =
        createDataItemsForDynamicChildren(data: data, context: context);
    final generateChildrenDynamically =
        data.dataRef.isNotEmpty && data.dataRef['kind'] != null;

    List<Widget> widgets;
    if (generateChildrenDynamically) {
      widgets = items
          .mapIndexed((index, element) {
            return children.map((child) {
              return Container(
                  height: props.childHeight?.toHeight(context),
                  width: props.childWidth?.toWidth(context),
                  padding: EdgeInsets.symmetric(horizontal: padding),
                  child: BracketScope(
                      variables: [('index', index), ('currentItem', element)],
                      builder: DUIJsonWidgetBuilder(
                          data: child, registry: registry!)));
            });
          })
          .expand((e) => e)
          .toList();
    } else {
      widgets = children.map((e) {
        final builder = DUIJsonWidgetBuilder(data: e, registry: registry!);
        return Container(
            height: props.childHeight?.toHeight(context),
            width: props.childWidth?.toWidth(context),
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: builder.build(context));
      }).toList();
    }

    return SizedBox(
      height: height,
      width: width,
      child: CarouselSlider.builder(
        itemCount: widgets.length,
        itemBuilder: (context, index, realIndex) {
          return widgets[index];
        },
        options: CarouselOptions(
          scrollDirection: DUIDecoder.toAxis(props.direction),
          aspectRatio: double.tryParse(props.aspectRatio ?? '1.78') ?? 1.78,
          autoPlay: props.autoPlay ?? false,
          autoPlayAnimationDuration: Duration(
              milliseconds:
                  int.tryParse(props.animationDuration ?? '800') ?? 800),
          autoPlayCurve: Curves.linear,
          autoPlayInterval: Duration(
              milliseconds:
                  int.tryParse(props.autoPlayInterval ?? '1600') ?? 1600),
          enableInfiniteScroll: props.infiniteScroll ?? false,
          initialPage: int.tryParse(props.initialPage ?? '1') ?? 1,
          viewportFraction:
              double.tryParse(props.viewportFraction ?? '0.8') ?? 0.8,
          enlargeFactor: double.tryParse(props.enlargeFactor ?? '0.3') ?? 0.3,
          enlargeCenterPage: props.enlargeCenterPage,
          reverse: props.reverseScroll ?? false,
        ),
      ),
    );
  }

  Widget _emptyChildWidget() {
    return const Text(
      'Children field is Empty!',
      textAlign: TextAlign.center,
    );
  }
}
