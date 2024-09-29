import 'package:flutter/widgets.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';

class VWCustomScrollView extends VirtualStatelessWidget<Props> {
  VWCustomScrollView(
      {required super.props,
      required super.commonProps,
      required super.parent,
      required super.refName,
      required super.childGroups,
      required super.repeatData});

  @override
  Widget render(RenderPayload payload) {
    final bool isReverse = payload.eval<bool>(props.get('reverse')) ?? false;
    final bool enableOverlapInjector =
        props.getBool('enableOverlapInjector') ?? true;

    return Builder(builder: (cntx) {
      return CustomScrollView(
        reverse: isReverse,
        scrollDirection:
            To.axis(props.getString('scrollDirection')) ?? Axis.vertical,
        physics: To.scrollPhysics(props.getBool('allowScroll')),
        slivers: getSlivers(cntx, enableOverlapInjector, payload),
      );
    });
  }

  List<Widget> getSlivers(
      BuildContext cntx, bool enableOverlapInjector, RenderPayload payload) {
    final sliverData = children;
    if (sliverData == null) {
      return [
        SliverToBoxAdapter(
          child: empty(),
        )
      ];
    }
    final sliverList = sliverData.map((e) {
      return e.toWidget(payload);
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
}
