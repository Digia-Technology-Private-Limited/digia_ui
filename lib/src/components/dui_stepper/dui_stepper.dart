import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/bracket_scope_provider.dart';
import '../../core/builders/common.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import '../dui_base_stateful_widget.dart';
import 'DashLineConnector.dart';

class DUIStepper extends BaseStatefulWidget {
  final Map<String, dynamic> props;
  final DUIWidgetJsonData data;

  const DUIStepper({
    super.key,
    required super.varName,
    required this.props,
    required this.data,
  });

  @override
  State<DUIStepper> createState() => _DUIStepperState();
}

class _DUIStepperState extends DUIWidgetState<DUIStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final animationTimeInSeconds =
        eval<int>(widget.props['animationTimeInSeconds'], context: context) ??
            0;
    final completedStepIndex =
        (eval<double>(widget.props['completedIndex'], context: context) ??
                0.0) -
            1.0;

    _controller = AnimationController(
      lowerBound: -1.6,
      upperBound: completedStepIndex,
      duration: Duration(seconds: animationTimeInSeconds),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Connector toConnectorType(dynamic value, Color color, double thickness) {
    //for backward COmpatible
    //need to remove ()
    if (value is String) {
      return switch (value) {
        'solid' => Connector.solidLine(
            color: color,
            thickness: thickness,
          ),
        'dashed' => CustomDashedLineConnector(
            color: color,
            thickness: thickness,
            dash: thickness * 3,
            gap: thickness * 2,
          ),
        _ => Connector.solidLine(
            color: color,
            thickness: thickness,
          )
      };
    }
    final connectorType = value?['value'];
    return switch (connectorType) {
      'solid' => Connector.solidLine(
          color: color,
          thickness: thickness,
        ),
      'dashed' => CustomDashedLineConnector(
          color: color,
          thickness: thickness,
          dash: value?['dash'] ?? thickness * 3,
          gap: value?['gap'] ?? thickness * 2,
          strokeCap: toStrokeCap(value?['strokeCap']),
        ),
      _ => Connector.solidLine(
          color: color,
          thickness: thickness,
        )
    };
  }

  StrokeCap toStrokeCap(dynamic value) {
    switch (value) {
      case 'square':
        return StrokeCap.square;
      case 'round':
        return StrokeCap.round;
      case 'butt':
      default:
        return StrokeCap.butt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.data.children['children'] ?? [];

    if (children.isEmpty) return _emptyChildWidget();

    final indicatorPosition =
        (eval<double>(widget.props['indicatorPosition'], context: context) ??
            0.5);

    final radius = eval<double>(widget.props['radius'], context: context) ?? 28;
    final thickness =
        eval<double>(widget.props['thickness'], context: context) ?? 5;
    final completedConnector = widget.props['completedConnector'];
    final inCompletedConnector = widget.props['inCompletedConnector'];
    final pendingIconProps =
        widget.props['pendingIcon'] as Map<String, dynamic>?;
    Widget? completedIcon;
    Widget? inCompletedIcon;
    DUIIconBuilder? pendingIcon =
        DUIIconBuilder.fromProps(props: pendingIconProps);
    final completedIconProps =
        widget.props['completedIcon'] as Map<String, dynamic>?;
    if (completedIconProps?['iconData'] != null) {
      completedIcon =
          DUIIconBuilder.fromProps(props: completedIconProps)?.build(context);
    }
    final inCompletedIconProps =
        widget.props['inCompletedIcon'] as Map<String, dynamic>?;
    if (inCompletedIconProps?['iconData'] != null) {
      inCompletedIcon =
          DUIIconBuilder.fromProps(props: inCompletedIconProps)?.build(context);
    }

    List items =
        createDataItemsForDynamicChildren(data: widget.data, context: context);
    final generateChildrenDynamically =
        widget.data.dataRef.isNotEmpty && widget.data.dataRef['kind'] != null;
    if (generateChildrenDynamically) {
      return Timeline.tileBuilder(
        shrinkWrap: true,
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: indicatorPosition,
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.after,
          // contentsAlign: ContentsAlign.alternating,
          itemCount: items.length,
          contentsBuilder: (context, index) {
            final childToRepeat = children.first;
            return BracketScope(
                variables: [('index', index), ('currentItem', items[index])],
                builder: DUIJsonWidgetBuilder(
                    data: childToRepeat, registry: DUIWidgetRegistry.shared));
          },
          indicatorBuilder: (context, index) {
            return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final double progress = _controller.value;
                  final bool isCompleted = index <= (progress).round();
                  final bool isPending = index == (progress).round() + 1;

                  return _buildIndicator(
                    pendingIcon: pendingIcon,
                    inPending: isPending,
                    isCompleted: isCompleted,
                    context: context,
                    completedIcon: completedIcon,
                    inCompletedIcon: inCompletedIcon,
                    radius: radius,
                    completedColor: eval<String>(widget.props['completedColor'],
                            context: context)
                        .letIfTrue(toColor),
                    inCompletedColor: eval<String>(
                            widget.props['inCompletedColor'],
                            context: context)
                        .letIfTrue(toColor),
                  );
                });
          },
          connectorBuilder: (context, index, connectorType) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double progress = _controller.value;
                final bool isCompleted = index <= (progress).round();
                final Color color = isCompleted
                    ? eval<String>(widget.props['completedColor'],
                                context: context)
                            .letIfTrue(toColor) ??
                        Colors.blue
                    : eval<String>(widget.props['inCompletedColor'],
                                context: context)
                            .letIfTrue(toColor) ??
                        Colors.white;

                if (isCompleted) {
                  return toConnectorType(completedConnector, color, thickness);
                }

                return toConnectorType(inCompletedConnector, color, thickness);
              },
            );
          },
        ),
      );
    } else {
      return Timeline.tileBuilder(
        shrinkWrap: true,
        theme: TimelineThemeData(
          nodePosition: 0,
          indicatorPosition: indicatorPosition,
        ),
        builder: TimelineTileBuilder.connected(
          connectionDirection: ConnectionDirection.after,
          itemCount: children.length,
          contentsBuilder: (context, index) {
            return DUIJsonWidgetBuilder(
                    data: children[index], registry: DUIWidgetRegistry.shared)
                .build(context);
          },
          indicatorBuilder: (context, index) {
            return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final double progress = _controller.value;
                  final bool isCompleted = index <= (progress).round();
                  final bool isPending = index == (progress).round() + 1;

                  return _buildIndicator(
                    pendingIcon: pendingIcon,
                    inPending: isPending,
                    isCompleted: isCompleted,
                    context: context,
                    completedIcon: completedIcon,
                    inCompletedIcon: inCompletedIcon,
                    radius: radius,
                    completedColor: eval<String>(widget.props['completedColor'],
                            context: context)
                        .letIfTrue(toColor),
                    inCompletedColor: eval<String>(
                            widget.props['inCompletedColor'],
                            context: context)
                        .letIfTrue(toColor),
                  );
                });
          },
          connectorBuilder: (context, index, connectorType) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double progress = _controller.value;
                final bool isCompleted = index <= (progress).round();
                final Color color = isCompleted
                    ? eval<String>(widget.props['completedColor'],
                                context: context)
                            .letIfTrue(toColor) ??
                        Colors.blue
                    : eval<String>(widget.props['inCompletedColor'],
                                context: context)
                            .letIfTrue(toColor) ??
                        Colors.white;

                if (isCompleted) {
                  return toConnectorType(completedConnector, color, thickness);
                }

                return toConnectorType(inCompletedConnector, color, thickness);
              },
            );
          },
        ),
      );
    }
  }

  Widget _emptyChildWidget() {
    return const Text(
      'Children field is Empty!',
      textAlign: TextAlign.center,
    );
  }

  Widget _buildIndicator({
    DUIIconBuilder? pendingIcon,
    required bool inPending,
    required bool isCompleted,
    required BuildContext context,
    required Widget? completedIcon,
    required Widget? inCompletedIcon,
    required double radius,
    required Color? completedColor,
    required Color? inCompletedColor,
  }) {
    Widget? icon;
    if (isCompleted) {
      icon = completedIcon;
    } else if (inPending) {
      if (pendingIcon == null) {
        icon = inCompletedIcon;
      } else {
        icon = pendingIcon.build(context); // Use the pending icon
      }
    } else {
      icon = inCompletedIcon;
    }

    final backgroundColor = isCompleted ? completedColor : inCompletedColor;
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(child: icon),
    );
  }

  @override
  Map<String, Function> getVariables() {
    return {};
  }
}
