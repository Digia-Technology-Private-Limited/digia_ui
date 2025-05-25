import 'package:flutter/material.dart';

import '../../base/virtual_stateless_widget.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../internal_widgets/tab_view/controller.dart';
import '../../internal_widgets/tab_view/inherited_tab_view_controller.dart';
import '../../models/props.dart';
import '../../render_payload.dart';
import '../../utils/flutter_type_converters.dart';

class VWTabBar extends VirtualStatelessWidget<Props> {
  VWTabBar({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    TabViewController? controller =
        InheritedTabViewController.maybeOf(payload.buildContext);
    if (controller == null) return empty();

    final selectedChild = childOf('selectedWidget');

    if (selectedChild == null) return empty();

    final indicatorSize = To.tabBarIndicatorSize(props.get('indicatorSize')) ??
        TabBarIndicatorSize.tab;
    final isScrollable = props.getBool('tabBarScrollable.value') ?? false;
    final alignment =
        To.alignment(props.getString('tabBarScrollable.tabAlignment')) ??
            Alignment.center;

    return ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(scrollbars: false),
      child: TabBar(
        automaticIndicatorColorAdjustment: false,
        isScrollable: isScrollable,
        tabAlignment: isScrollable
            ? alignment == Alignment.centerLeft
                ? TabAlignment.start
                : TabAlignment.center
            : null,
        indicatorSize: indicatorSize,
        controller: controller,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        padding: To.edgeInsets(props.get('tabBarPadding')),
        labelPadding: To.edgeInsets(props.get('labelPadding')),
        dividerColor: payload.evalColor(props.get('dividerColor')),
        dividerHeight: props.getDouble('dividerHeight'),
        indicatorWeight: props.getDouble('indicatorWeight') ?? 2.0,
        indicatorColor: payload.evalColor(props.get('indicatorColor')),
        tabs: List.generate(controller.length, (index) {
          return AnimatedBuilder(
            animation: controller.animation!,
            builder: (innerCtx, child) {
              final updatedPayload = payload.copyWithChainedContext(
                _createExprContext(
                  controller.tabs[index],
                  index,
                ),
                buildContext: innerCtx,
              );

              final child = controller.index == index
                  ? selectedChild
                  : childOf('unselectedWidget') ?? selectedChild;

              return child.toWidget(updatedPayload);
            },
          );
        }),
      ),
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    return DefaultScopeContext(variables: {
      'currentItem': item,
      'index': index,
    });
  }
}
