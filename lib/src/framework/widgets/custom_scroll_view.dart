import 'package:flutter/widgets.dart';
import '../base/virtual_sliver.dart';
import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../widget_props/custom_scroll_view_props.dart';
import 'grid_view.dart';
import 'list_view.dart';
import 'nested_scroll_view.dart';
import 'paginated_list_view.dart';
import 'paginated_sliver_list.dart';
import 'sliver_grid.dart';
import 'sliver_list.dart';
import 'sliver_to_box_adaptor.dart';

class VWCustomScrollView extends VirtualStatelessWidget<CustomScrollViewProps> {
  VWCustomScrollView({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  // Map of box widgets to their sliver counterparts
  static final Map<Type, Function(VirtualStatelessWidget)> _boxToSliverMap = {
    VWListView: (widget) => VWSliverList(
          props: widget.props,
          commonProps: null,
          parent: widget.parent,
          refName: widget.refName,
          childGroups: widget.childGroups,
        ),
    VWGridView: (widget) => VWSliverGrid(
          props: widget.props,
          commonProps: null,
          parent: widget.parent,
          refName: widget.refName,
          childGroups: widget.childGroups,
        ),
    VWPaginatedListView: (widget) => VWPaginatedSliverList(
          props: widget.props,
          commonProps: null,
          parent: widget.parent,
          refName: widget.refName,
          childGroups: widget.childGroups,
        ),
  };

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
            if (e is VirtualSliver) return e;

            final converter = _boxToSliverMap[e.runtimeType];
            if (converter != null && e is VirtualStatelessWidget) {
              return converter(e);
            }

            // Default fallback for other widgets
            return VWSliverToBoxAdaptor(e);
          }).map((child) => child.toWidget(payload))
        ]);
  }
}
