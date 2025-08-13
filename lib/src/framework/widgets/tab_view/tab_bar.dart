import 'package:flutter/material.dart';

import '../../base/virtual_stateless_widget.dart';
import '../../custom/border_with_pattern.dart';
import '../../custom/custom_flutter_types.dart';
import '../../expr/default_scope_context.dart';
import '../../expr/scope_context.dart';
import '../../internal_widgets/tab_view/controller.dart';
import '../../internal_widgets/tab_view/inherited_tab_view_controller.dart';
import '../../models/props.dart';
import '../../render_payload.dart';
import '../../utils/flutter_type_converters.dart';
import '../../utils/functional_util.dart';

class VWTabBar extends VirtualStatelessWidget<Props> {
  VWTabBar({
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
        indicator: props.getBool('hasIndicatorDecoration') ?? false
            ? _buildIndicatorDecoration(payload)
            : null,
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

  Decoration? _buildIndicatorDecoration(RenderPayload payload) {
    final indicatorProps = props.toProps('indicatorDecoration');
    if (indicatorProps == null || indicatorProps.isEmpty) return null;

    final gradient = To.gradient(indicatorProps.getMap('gradiant'),
        evalColor: payload.evalColor);
    final color = gradient != null
        ? null
        : payload.evalColor(indicatorProps.get('color'));

    final BoxShape shape = indicatorProps.getString('shape') == 'circle'
        ? BoxShape.circle
        : BoxShape.rectangle;
    final borderRadius = To.borderRadius(indicatorProps.get('borderRadius'));

    final border = _toBorderWithPattern(
        payload, indicatorProps.toProps('border') ?? Props.empty());

    return BoxDecoration(
      gradient: gradient,
      color: color,
      border: border,
      borderRadius: shape == BoxShape.circle ? null : borderRadius,
      shape: shape,
    );
  }

  BoxBorder? _toBorderWithPattern(RenderPayload payload, Props props) {
    if (props.isEmpty) return null;

    final strokeWidth = props.getDouble('borderWidth') ?? 0;
    if (strokeWidth <= 0) return null;

    final borderColor =
        payload.evalColor(props.get('borderColor')) ?? Colors.transparent;
    final dashPattern =
        To.dashPattern(props.get('borderType.dashPattern')) ?? const [3, 1];
    final strokeCap =
        To.strokeCap(props.get('borderType.strokeCap')) ?? StrokeCap.butt;
    final borderGradiant = To.gradient(props.getMap('borderGradiant'),
        evalColor: payload.evalColor);
    final BorderPattern borderPattern =
        To.borderPattern(props.get('borderType.borderPattern')) ??
            BorderPattern.solid;
    final strokeAlign =
        To.strokeAlign(props.get('strokeAlign')) ?? StrokeAlign.center;

    return BorderWithPattern(
      strokeWidth: strokeWidth,
      color: borderColor,
      dashPattern: dashPattern,
      strokeCap: strokeCap,
      gradient: borderGradiant,
      borderPattern: borderPattern,
      strokeAlign: strokeAlign,
    );
  }

  ScopeContext _createExprContext(Object? item, int index) {
    final tabBarObj = {
      'currentItem': item,
      'index': index,
    };

    return DefaultScopeContext(variables: {
      ...tabBarObj,
      ...?refName.maybe((it) => {it: tabBarObj}),
    });
  }
}
