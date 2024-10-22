import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../Utils/util_functions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import 'dui_custom_tab_controller.dart';
import 'dui_tab_bar_props.dart';

class DUITabBar extends StatelessWidget {
  final DUIWidgetRegistry? registry;
  final DUIWidgetJsonData data;
  final DUITabBarProps tabBarProps;

  DUITabBar({
    super.key,
    required this.registry,
    required this.data,
    required this.tabBarProps,
  });

  late TabBarIndicatorSize _indicatorSize;

  late DUICustomTabController _controller;

  Widget generateWidget(
      DUIWidgetJsonData child, int index, List<dynamic> list) {
    return BracketScope(
      // key:
      //     ValueKey('${isSelectedWidget ? 'selected' : 'notSelected'}_$index'),
      variables: [('index', index), ('currentItem', list[index])],
      builder: DUIJsonWidgetBuilder(
        data: child,
        registry: registry ?? DUIWidgetRegistry.shared,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _controller = DUITabControllerProvider.of(context);
    final selectedChild = _getChildWidget('selectedWidget');
    final unselectedChild = _getChildWidget('unselectedWidget');
    // final animationType =
    //     getTransitionBuilder(widget.tabBarProps.animationType);
    _indicatorSize = _toTabBarIndicatorSize(tabBarProps.indicatorSize) ??
        TabBarIndicatorSize.tab;
    final bool isScrollable =
        tabBarProps.tabBarScrollable?.valueFor(keyPath: 'value') as bool? ??
            false;
    final alignment = DUIDecoder.toAlignment(
            tabBarProps.tabBarScrollable?.valueFor(keyPath: 'tabAlignment')) ??
        Alignment.center;

    if (selectedChild == null) return _emptyChildWidget();
    final dataList = _controller.dynamicList;
    return TabBar(
      isScrollable: isScrollable,
      tabAlignment: isScrollable
          ? alignment == Alignment.centerLeft
              ? TabAlignment.start
              : TabAlignment.center
          : null,
      indicatorSize: _indicatorSize,
      controller: _controller,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      padding: DUIDecoder.toEdgeInsets(tabBarProps.tabBarPadding),
      labelPadding: DUIDecoder.toEdgeInsets(tabBarProps.labelPadding),
      dividerColor: makeColor(tabBarProps.dividerColor),
      dividerHeight: tabBarProps.dividerHeight,
      indicatorWeight: tabBarProps.indicatorWeight ?? 2.0,
      indicatorColor: makeColor(tabBarProps.indicatorColor),
      tabs: List.generate(dataList.length, (index) {
        if (unselectedChild == null) {
          return generateWidget(selectedChild, index, dataList);
        }
        return AnimatedBuilder(
          animation: _controller.animation!,
          builder: (context, child) {
            final isSelected = _controller.index == index;
            final selectedWidget =
                generateWidget(selectedChild, index, dataList);
            final notSelectedWidget =
                generateWidget(unselectedChild, index, dataList);
            return isSelected ? selectedWidget : notSelectedWidget;
          },
        );
      }),
    );
  }

  DUIWidgetJsonData? _getChildWidget(String key) {
    final children = data.children[key] ?? [];
    return children.isEmpty ? null : children.first;
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
}
