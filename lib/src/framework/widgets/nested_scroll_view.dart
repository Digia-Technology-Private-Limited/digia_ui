import 'package:flutter/widgets.dart';

import '../base/virtual_stateless_widget.dart';
import '../render_payload.dart';
import '../widget_props/nested_scroll_view_props.dart';

class NestedScrollViewData extends InheritedWidget {
  final bool
      enableOverlapAbsorption; // Replace SomeDataType with your actual data type

  const NestedScrollViewData({
    super.key,
    required this.enableOverlapAbsorption,
    required super.child,
  });

  static NestedScrollViewData? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<NestedScrollViewData>();
  }

  @override
  bool updateShouldNotify(NestedScrollViewData oldWidget) => false;
}

class VWNestedScrollView extends VirtualStatelessWidget<NestedScrollViewProps> {
  VWNestedScrollView({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  @override
  Widget render(RenderPayload payload) {
    final controller = payload.evalExpr(props.controller);

    final enableOverlapAbsorption =
        props.enableOverlapAbsorber?.evaluate(payload.scopeContext) ?? true;

    final header = childrenOf('headerWidget')?.firstOrNull;
    final body = childOf('bodyWidget');

    final cachedHeaderWidget =
        header?.toWidget(payload) ?? SliverToBoxAdapter(child: empty());

    return NestedScrollView(
        controller: controller,
        headerSliverBuilder: (innerCtx, innerBoxIsScrolled) {
          Widget output = cachedHeaderWidget;

          if (enableOverlapAbsorption) {
            output = SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(innerCtx),
              sliver: output,
            );
          }

          return <Widget>[output];
        },
        body: NestedScrollViewData(
          enableOverlapAbsorption: enableOverlapAbsorption,
          child: Builder(builder: (innerCtx) {
            final updatedPayload = payload.copyWith(buildContext: innerCtx);
            return body?.toWidget(updatedPayload) ?? empty();
          }),
        ));
  }
}
