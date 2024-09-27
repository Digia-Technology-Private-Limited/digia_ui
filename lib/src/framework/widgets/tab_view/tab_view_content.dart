import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../base/virtual_stateless_widget.dart';
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
    required super.childGroups,
    required super.parent,
    super.refName,
    super.repeatData,
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
          return child!.toWidget(payload.copyWithChainedContext(
            _createExprContext(
              controller.tabs[index],
              index,
            ),
          ));
        }));
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index,
    });
  }
}
