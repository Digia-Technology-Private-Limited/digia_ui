import 'package:flutter/widgets.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import '../utils/functional_util.dart';
import '../utils/sliver_util.dart';
import '../widget_props/smart_scroll_view_props.dart';
import 'nested_scroll_view.dart';

class VWSmartScrollView extends VirtualStatelessWidget<SmartScrollViewProps> {
  VWSmartScrollView({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.parent,
    required super.refName,
    required super.childGroups,
  });

  bool get shouldRepeatChild => props.dataSource != null;

  @override
  Widget render(RenderPayload payload) {
    final controller = payload.evalExpr(props.controller);

    final bool isReverse = payload.evalExpr<bool>(props.isReverse) ?? false;
    final bool enableOverlapInjector =
        NestedScrollViewData.maybeOf(payload.buildContext)
                ?.enableOverlapAbsorption ??
            false;

    if (shouldRepeatChild && (children?.isNotEmpty ?? false)) {
      final List items =
          props.dataSource?.evaluate(payload.scopeContext) as List? ?? [];

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
          ...List.generate(items.length, (index) {
            final dataItem = items[index];
            final template = SliverUtil.convertToSliver(children!.first);
            return template.toWidget(
              payload.copyWithChainedContext(
                _createExprContext(dataItem, index),
              ),
            );
          }),
        ],
      );
    }

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
        ...?children
            ?.map((e) => SliverUtil.convertToSliver(e))
            .map((child) => child.toWidget(payload)),
      ],
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final smartScrollViewObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...smartScrollViewObj,
      ...?refName.maybe((it) => {it: smartScrollViewObj}),
    });
  }
}
