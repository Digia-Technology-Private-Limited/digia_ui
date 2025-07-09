// Map of box widgets to their sliver counterparts
import '../base/virtual_sliver.dart';
import '../base/virtual_stateless_widget.dart';
import '../base/virtual_widget.dart';
import '../widgets/grid_view.dart';
import '../widgets/list_view.dart';
import '../widgets/paginated_list_view.dart';
import '../widgets/paginated_sliver_list.dart';
import '../widgets/sliver_grid.dart';
import '../widgets/sliver_list.dart';
import '../widgets/sliver_to_box_adaptor.dart';

class SliverUtil {
  static final Map<Type, Function(VirtualStatelessWidget)> boxToSliverMap = {
    VWListView: (widget) => VWSliverList(
          props: widget.props,
          commonProps: widget.commonProps,
          parent: widget.parent,
          refName: widget.refName,
          childGroups: widget.childGroups,
        ),
    VWGridView: (widget) => VWSliverGrid(
          props: widget.props,
          commonProps: widget.commonProps,
          parent: widget.parent,
          refName: widget.refName,
          childGroups: widget.childGroups,
        ),
    VWPaginatedListView: (widget) => VWPaginatedSliverList(
          props: widget.props,
          commonProps: widget.commonProps,
          parent: widget.parent,
          refName: widget.refName,
          childGroups: widget.childGroups,
        ),
  };

  /// Converts a widget to a sliver if possible
  /// Returns the original widget as VWSliverToBoxAdaptor if no converter is found
  static VirtualWidget convertToSliver(dynamic widget) {
    if (widget is VirtualSliver) return widget;

    final converter = boxToSliverMap[widget.runtimeType];
    if (converter != null && widget is VirtualStatelessWidget) {
      return converter(widget);
    }

    // Default fallback for other widgets
    return VWSliverToBoxAdaptor(widget);
  }
}
