import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../../digia_ui.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import 'dui_json_widget_builder.dart';

class DUIStepperBuilder extends DUIWidgetBuilder {
  DUIStepperBuilder(DUIWidgetJsonData data, DUIWidgetRegistry? registry)
      : super(data: data, registry: registry);

  static DUIStepperBuilder create(DUIWidgetJsonData data,
      {DUIWidgetRegistry? registry}) {
    return DUIStepperBuilder(data, registry);
  }

  @override
  Widget build(BuildContext context) {
    if (registry == null) {
      return fallbackWidget();
    }
    final completedStepIndex =
        eval<int>(data.props['completedIndex'], context: context) ?? -1;
    final radius = eval<double>(data.props['radius'], context: context) ?? 28;
    final thickness =
        eval<double>(data.props['thickness'], context: context) ?? 5;

    Widget? completedIcon;
    Widget? inCompletedIcon;
    final completedIconProps =
        data.props['completedIcon'] as Map<String, dynamic>?;
    if (completedIconProps?['iconData'] != null) {
      completedIcon =
          DUIIconBuilder.fromProps(props: completedIconProps).build(context);
    }
    final inCompletedIconProps =
        data.props['inCompletedIcon'] as Map<String, dynamic>?;
    if (inCompletedIconProps?['iconData'] != null) {
      inCompletedIcon =
          DUIIconBuilder.fromProps(props: inCompletedIconProps).build(context);
    }
    final children = data.children['children'];
    if (children == null) {
      return const SizedBox.shrink();
    }
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return Timeline.tileBuilder(
      shrinkWrap: true,
      theme: TimelineThemeData(
        nodePosition: 0,
        // color: Colors.grey,
        // indicatorTheme: IndicatorThemeData(size: 20),
        // connectorTheme: ConnectorThemeData(thickness: 2),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.after,
        itemCount: children.length,
        contentsBuilder: (context, index) {
          return DUIJsonWidgetBuilder(
                  data: children[index], registry: registry!)
              .build(context);
        },
        indicatorBuilder: (context, index) {
          return _buildIndicator(
              isCompleted: index <= completedStepIndex,
              context: context,
              completedIcon: completedIcon,
              inCompletedIcon: inCompletedIcon,
              radius: radius,
              completedColor:
                  eval<String>(data.props['completedColor'], context: context)
                      .letIfTrue(toColor),
              inCompletedColor:
                  eval<String>(data.props['inCompletedColor'], context: context)
                      .letIfTrue(toColor));
        },
        connectorBuilder: (context, index, connectorType) {
          return SolidLineConnector(
            color: index < completedStepIndex
                ? eval<String>(data.props['completedColor'], context: context)
                    .letIfTrue(toColor)
                : eval<String>(data.props['inCompletedColor'], context: context)
                    .letIfTrue(toColor),
            thickness: thickness,
          );
        },
      ),
    );
  }

  Widget _buildIndicator({
    required bool isCompleted,
    required BuildContext context,
    required Widget? completedIcon,
    required Widget? inCompletedIcon,
    required double radius,
    required Color? completedColor,
    required Color? inCompletedColor,
  }) {
    completedIcon = completedIcon ??
        const Icon(Icons.radio_button_checked, color: Colors.blue);
    inCompletedIcon = inCompletedIcon ??
        const Icon(Icons.radio_button_unchecked, color: Colors.grey);
    return isCompleted
        ? CircleAvatar(
            radius: radius,
            backgroundColor: completedColor,
            child: completedIcon,
          )
        : CircleAvatar(
            radius: radius,
            backgroundColor: inCompletedColor,
            child: inCompletedIcon,
          );
  }
}
