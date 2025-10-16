import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../base/virtual_stateless_widget.dart';
import '../data_type/adapted_types/scroll_controller.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import '../widget_props/masonry_grid_view_props.dart';

class VWMasonryGridView extends VirtualStatelessWidget<MasonryGridViewProps> {
  VWMasonryGridView({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  bool get shouldRepeatChild => props.dataSource != null;

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final controller =
        payload.evalExpr<AdaptedScrollController>(props.controller);
    final allowScroll = payload.evalExpr<bool>(props.allowScroll) ?? true;
    final physics = allowScroll ? null : const NeverScrollableScrollPhysics();
    final shrinkWrap = payload.evalExpr<bool>(props.shrinkWrap) ?? false;
    final crossAxisCount = payload.evalExpr<int>(props.crossAxisCount) ?? 2;
    final mainAxisSpacing =
        payload.evalExpr<double>(props.mainAxisSpacing) ?? 0.0;
    final crossAxisSpacing =
        payload.evalExpr<double>(props.crossAxisSpacing) ?? 0.0;

    if (shouldRepeatChild) {
      final items = payload.eval<List<Object>>(
              props.dataSource?.evaluate(payload.scopeContext)) ??
          [];
      return MasonryGridView.count(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        itemCount: items.length,
        itemBuilder: (buildContext, index) {
          return child!.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(items[index], index),
              buildContext: buildContext,
            ),
          );
        },
      );
    }

    return MasonryGridView.count(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      itemCount: -1,
      itemBuilder: (buildContext, index) {
        return child!.toWidget(payload.copyWith(buildContext: buildContext));
      },
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final gridObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...gridObj,
      if (refName != null) refName!: gridObj,
    });
  }
}
