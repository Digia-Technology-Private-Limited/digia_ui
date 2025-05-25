import 'package:flutter/widgets.dart';
import '../base/extensions.dart';
import '../base/virtual_sliver.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/custom_scroll_view_props.dart';
import 'nested_scroll_view.dart';
import 'sliver_to_box_adaptor.dart';

class VWCustomScrollView extends VirtualStatelessWidget<CustomScrollViewProps> {
  VWCustomScrollView({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final controller = payload.evalExpr(props.controller);

    final bool isReverse = payload.evalExpr<bool>(props.isReverse) ?? false;
    final bool enableOverlapInjector =
        NestedScrollViewData.maybeOf(payload.buildContext)
                ?.enableOverlapAbsorption ??
            false;

    return CustomScrollView(
        controller: controller,
        reverse: isReverse,
        scrollDirection: To.axis(props.scrollDirection) ?? Axis.vertical,
        physics: To.scrollPhysics(props.allowScroll),
        slivers: [
          if (enableOverlapInjector)
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                payload.buildContext,
              ),
            ),
          ...?children?.map((e) {
            if (e is! VirtualSliver) return VWSliverToBoxAdaptor(e);

            return e;
          }).toWidgetArray(payload)
        ]);
  }
}
