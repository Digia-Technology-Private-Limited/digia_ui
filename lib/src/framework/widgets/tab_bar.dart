import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../Utils/util_functions.dart';
import '../core/extensions.dart';
import '../../Utils/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../internal_widgets/internal_tab_bar.dart';
import '../render_payload.dart';

class VWTabBar extends VirtualStatelessWidget {
  VWTabBar({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    if (children == null || children!.isEmpty) return empty();
    final selectedWidget = List.castFrom(children!).map((child) {
      if (child is! VirtualStatelessWidget) return empty();
      return child.childrenOf('selectedWidget')?.first.render(payload);
    });
    final notSelectedWidget = List.castFrom(children!).map((child) {
      if (child is! VirtualStatelessWidget) return empty();
      return child.childrenOf('notSelectedWidget')?.first.render(payload);
    });
    return InternalTabBar(
      tabBarIndicatorSize:
          toTabBarIndicatorSize(props.getString('indicatorSize')),
      tabBarScrollable:
          props.getMap('tabBarScrollable')?.valueFor(keyPath: 'value') ?? false,
      tabBarAlignment: DUIDecoder.toAlignment(props
              .getMap('tabBarScrollable')
              ?.valueFor(keyPath: 'tabAlignment')) ??
          Alignment.center,
      dividerColor: makeColor(props.get('dividerColor')),
      indicatorColor: makeColor(props.get('indicatorColor')),
      dividerHeight: props.getDouble('dividerHeight'),
      indicatorWeight: props.getDouble('indicatorWeight'),
      tabBarPadding: DUIDecoder.toEdgeInsets(props.get('tabBarPadding')),
      labelPadding: DUIDecoder.toEdgeInsets(props.get('labelPading')),
      selectedWidget: selectedWidget,
    );
  }

  ExprContext _createExprContext(Object? item, int index) {
    return ExprContext(variables: {
      'currentItem': item,
      'index': index
      // TODO: Add class instance using refName
    });
  }
}

TabBarIndicatorSize? toTabBarIndicatorSize(dynamic value) => switch (value) {
      'tab' => TabBarIndicatorSize.tab,
      'label' => TabBarIndicatorSize.label,
      _ => null
    };
