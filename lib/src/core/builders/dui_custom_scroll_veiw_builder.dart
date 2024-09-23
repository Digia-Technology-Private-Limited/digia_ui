import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';

class DUICustomScrollViewBuilder extends DUIWidgetBuilder {
  DUICustomScrollViewBuilder(
      DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUICustomScrollViewBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUICustomScrollViewBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }

    final bool isReverse =
        eval<bool>(data.props['reverse'], context: context) ?? false;
    final bool enableOverlapInjector =
        NumDecoder.toBool(data.props['enableOverlapInjector']) ?? false;

    return Builder(builder: (cntx) {
      return CustomScrollView(
        reverse: isReverse,
        scrollDirection: DUIDecoder.toAxis(data.props['scrollDirection'],
            defaultValue: Axis.vertical),
        physics: DUIDecoder.toScrollPhysics(data.props['allowScroll']),
        slivers: getSlivers(cntx, enableOverlapInjector),
      );
    });
  }

  List<Widget> getSlivers(BuildContext cntx, bool enableOverlapInjector) {
    final sliverData = data.children['children'];
    if (sliverData == null) {
      return const [
        SliverToBoxAdapter(
          child: SizedBox.shrink(),
        )
      ];
    }
    final sliverList = sliverData.map((e) {
      return DUIWidget(data: e);
    }).toList();

    final slivers = <Widget>[];
    if (enableOverlapInjector) {
      slivers.add(SliverOverlapInjector(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(cntx),
      ));
    }
    slivers.addAll(sliverList);

    return slivers;
  }

  @override
  Widget fallbackWidget() {
    return const Text('Registry not found for custom scroll view');
  }
}
