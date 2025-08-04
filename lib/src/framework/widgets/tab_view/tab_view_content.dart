import 'package:flutter/material.dart';

import '../../base/virtual_stateless_widget.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../internal_widgets/keep_alive_widget.dart';
import '../../internal_widgets/tab_view/controller.dart';
import '../../internal_widgets/tab_view/inherited_tab_view_controller.dart';
import '../../render_payload.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';
import '../../widget_props/tab_view_content_props.dart';

class VWTabViewContent extends VirtualStatelessWidget<TabViewContentProps> {
  VWTabViewContent({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    TabViewController? controller =
        InheritedTabViewController.maybeOf(payload.buildContext);
    if (controller == null) return empty();

    if (child == null) return empty();

    return TabBarView(
        controller: controller,
        physics: props.isScrollable.maybe(To.scrollPhysics),
        viewportFraction: props.viewportFraction,
        children: List.generate(controller.length, (index) {
          final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(
              controller.tabs[index],
              index,
            ),
          );
          return KeepAliveWrapper(
            keepTabsAlive: updatedPayload.evalExpr<bool>(props.keepTabsAlive),
            child: child!.toWidget(updatedPayload),
          );
        }));
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final tabViewContentObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...tabViewContentObj,
      ...?refName.maybe((it) => {it: tabViewContentObj}),
    });
  }
}
