import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../../Utils/extensions.dart';
import '../../../Utils/util_functions.dart';
import '../../base/virtual_stateless_widget.dart';
import '../../internal_widgets/tab_view/controller.dart';
import '../../internal_widgets/tab_view/tab_view_controller_provider.dart';
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
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    TabViewController? controller =
        TabViewControllerProvider.maybeOf(payload.buildContext);
    if (controller == null) return empty();

    final selectedChild = childOf('selectedWidget');

    if (selectedChild == null) return empty();

    final indicatorSize = To.tabBarIndicatorSize(props.get('indicatorSize')) ??
        TabBarIndicatorSize.tab;
    final isScrollable =
        props.getMap('tabBarScrollable')?.valueFor(keyPath: 'value') ?? false;
    final alignment = DUIDecoder.toAlignment(props
            .getMap('tabBarScrollable')
            ?.valueFor(keyPath: 'tabAlignment')) ??
        Alignment.center;

    return TabBar(
      isScrollable: isScrollable,
      tabAlignment: isScrollable
          ? alignment == Alignment.centerLeft
              ? TabAlignment.start
              : TabAlignment.center
          : null,
      indicatorSize: indicatorSize,
      controller: controller,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      padding: DUIDecoder.toEdgeInsets(props.get('tabBarPadding')),
      labelPadding: DUIDecoder.toEdgeInsets(props.get('labelPadding')),
      dividerColor: makeColor(props.get('dividerColor')),
      dividerHeight: props.getDouble('dividerHeight'),
      indicatorWeight: props.getDouble('indicatorWeight') ?? 2.0,
      indicatorColor: makeColor(props.get('indicatorColor')),
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
    );
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index,
    });
  }
}
