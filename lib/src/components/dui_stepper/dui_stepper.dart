import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/util_functions.dart';
import '../../core/builders/dui_icon_builder.dart';
import '../../core/builders/dui_json_widget_builder.dart';
import '../../core/evaluator.dart';
import '../dui_base_stateful_widget.dart';

class DUIStepper extends BaseStatefulWidget {
  final Map<String, dynamic> props;
  final List<DUIWidgetJsonData>? children;

  const DUIStepper({
    super.key,
    required super.varName,
    required this.props,
    this.children,
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

  @override
  Widget build(BuildContext context) {
    if (widget.children == null) {
      return const SizedBox.shrink();
    }

    // final completedStepIndex =
    //     (eval<int>(widget.props['completedIndex'], context: context) ?? 0) - 1;
    final radius = eval<double>(widget.props['radius'], context: context) ?? 28;
    final thickness =
        eval<double>(widget.props['thickness'], context: context) ?? 5;

    Widget? completedIcon;
    Widget? inCompletedIcon;
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

    return Timeline.tileBuilder(
      shrinkWrap: true,
      theme: TimelineThemeData(
        nodePosition: 0,
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.after,
        itemCount: widget.children!.length,
        contentsBuilder: (context, index) {
          return DUIJsonWidgetBuilder(
                  data: widget.children![index],
                  registry: DUIWidgetRegistry.shared)
              .build(context);
        },
        indicatorBuilder: (context, index) {
          return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double progress = _controller.value;
                final bool isCompleted = index <= (progress).round();
                return _buildIndicator(
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

              return SolidLineConnector(
                color: color,
                thickness: thickness,
              );
            },
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
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: isCompleted ? completedColor : inCompletedColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted ? completedIcon : inCompletedIcon,
      ),
    );
  }

  @override
  Map<String, Function> getVariables() {
    return {};
  }
}
