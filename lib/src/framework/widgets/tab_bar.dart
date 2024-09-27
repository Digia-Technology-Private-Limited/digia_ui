import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_tab_controller.dart';
import '../render_payload.dart';

class VWTabBar extends VirtualStatelessWidget {
  VWTabBar({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  late InternalTabController _controller;

  @override
  Widget render(RenderPayload payload) {
    final selectedChild = childOf('selectedWidget');
    if (selectedChild.isNull) return empty();
    final unselectedChild = childOf('unselectedWidget');
    _controller = InternalTabControllerProvider.of(payload.buildContext);
    final indicatorSize = _toTabBarIndicatorSize(props.get('indicatorSize')) ??
        TabBarIndicatorSize.tab;
    final isScrollable =
        props.getMap('tabBarScrollable')?.valueFor(keyPath: 'value') ?? false;
    final alignment = DUIDecoder.toAlignment(props
            .getMap('tabBarScrollable')
            ?.valueFor(keyPath: 'tabAlignment')) ??
        Alignment.center;
    if (selectedChild.isNull) return _emptyChildWidget();
    final dataList = _controller.dynamicList;
    return TabBar(
      isScrollable: isScrollable,
      tabAlignment: isScrollable
          ? alignment == Alignment.centerLeft
              ? TabAlignment.start
              : TabAlignment.center
          : null,
      indicatorSize: indicatorSize,
      controller: _controller,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      padding: DUIDecoder.toEdgeInsets(props.get('tabBarPadding')),
      labelPadding: DUIDecoder.toEdgeInsets(props.get('labelPadding')),
      dividerColor: makeColor(props.get('dividerColor')),
      dividerHeight: props.getDouble('dividerHeight'),
      indicatorWeight: props.getDouble('indicatorWeight') ?? 2.0,
      indicatorColor: makeColor(props.get('indicatorColor')),
      tabs: List.generate(dataList.length, (index) {
        if (unselectedChild.isNull) {
          return selectedChild!.toWidget(payload.copyWithChainedContext(
              _createExprContext(dataList[index], index)));
        }
        return AnimatedBuilder(
          animation: _controller.animation!,
          builder: (context, child) {
            final isSelected = _controller.index == index;
            final selectedWidget = selectedChild!.toWidget(
                payload.copyWithChainedContext(
                    _createExprContext(dataList[index], index)));
            final notSelectedWidget = unselectedChild!.toWidget(
                payload.copyWithChainedContext(
                    _createExprContext(dataList[index], index)));
            return isSelected ? selectedWidget : notSelectedWidget;
          },
        );
      }),
    );
  }

  Widget _emptyChildWidget() {
    return const Center(
      child: Text(
        'Children field is Empty!',
        textAlign: TextAlign.center,
      ),
    );
  }

  TabBarIndicatorSize? _toTabBarIndicatorSize(dynamic value) => switch (value) {
        'tab' => TabBarIndicatorSize.tab,
        'label' => TabBarIndicatorSize.label,
        _ => null
      };

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {'currentItem': item, 'index': index});
  }
}
