import 'package:flutter/material.dart';
import '../../base/virtual_stateless_widget.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../internal_widgets/tab_view/tab_view_controller_scope_widget.dart';
import '../../render_payload.dart';
import '../../widget_props/tab_view_controller_props.dart';

class VWTabViewController
    extends VirtualStatelessWidget<TabViewControllerProps> {
  VWTabViewController({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    if (child == null) return empty();

    final tabs = payload.evalExpr<List>(props.tabs) ?? [];
    final initialIndex = payload.evalExpr<int>(props.initialIndex) ?? 0;

    void onTabChange(int currentIndex, Object? currentItem) {
      payload.executeAction(props.onTabChange,
          scopeContext: _createExprContext(currentIndex, currentItem));
    }

    return TabViewControllerScopeWidget(
      onTabChange: (currentIndex, currentItem) =>
          onTabChange(currentIndex, currentItem),
      tabs: tabs,
      initialIndex: initialIndex,
      childBuilder: (innerCtx) {
        final updatedPayload = payload.copyWith(buildContext: innerCtx);
        return child!.toWidget(updatedPayload);
      },
    );
  }

  ScopeContext _createExprContext(int? currentIndex, Object? currentItem) {
    return DefaultScopeContext(
        variables: {'index': currentIndex, 'currentItem': currentItem});
  }
}
