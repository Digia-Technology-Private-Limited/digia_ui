import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/bottom_navigation_bar.dart' as internal;
import '../models/props.dart';
import '../render_payload.dart';
import '../utils/flutter_type_converters.dart';
import 'bottom_navigation_bar_item.dart';

class VWBottomNavigationBar extends VirtualStatelessWidget<Props> {
  void Function(int)? onDestinationSelected;

  VWBottomNavigationBar({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
    this.onDestinationSelected,
  }) : super(repeatData: null);

  void handleDestinationSelected(int index, RenderPayload payload) {
    final selectedChild = children?.elementAt(index);
    if (selectedChild is VWBottomNavigationBarItem) {
      final actionValue = selectedChild.props.get('onPageSelected');
      final onClick = ActionFlow.fromJson(actionValue);
      payload.executeAction(onClick);
    }
    onDestinationSelected?.call(index);
  }

  @override
  Widget render(RenderPayload payload) {
    final backgroundColor = payload.evalColor(props.get('backgroundColor'));
    final animationDuration = Duration(
        milliseconds: payload.eval<int>(props.get('animationDuration')) ?? 0);
    final elevation = payload.eval<double>(props.get('elevation'));
    final height = payload.eval<double>(props.get('height'));
    final surfaceTintColor = payload.evalColor(props.get('surfaceTintColor'));
    final overlayColor =
        WidgetStateProperty.all(payload.evalColor(props.get('overlayColor')));
    final indicatorColor = payload.evalColor(props.get('indicatorColor'));
    final indicatorShape =
        To.buttonShape((props.get('indicatorShape')), payload.getColor);
    final showLabels = payload.eval<bool>(props.get('showLabels')) ?? true
        ? NavigationDestinationLabelBehavior.alwaysShow
        : NavigationDestinationLabelBehavior.alwaysHide;

    final destinations = children?.whereType<VWBottomNavigationBarItem>();

    return internal.BottomNavigationBar(
      backgroundColor: backgroundColor,
      animationDuration: animationDuration,
      elevation: elevation,
      height: height,
      surfaceTintColor: surfaceTintColor,
      overlayColor: overlayColor,
      indicatorColor: indicatorColor,
      indicatorShape: indicatorShape,
      labelBehavior: showLabels,
      destinations:
          destinations?.map((e) => e.toWidget(payload)).toList() ?? [],
      onDestinationSelected: (value) {
        handleDestinationSelected(value, payload);
      },
    );
  }
}
