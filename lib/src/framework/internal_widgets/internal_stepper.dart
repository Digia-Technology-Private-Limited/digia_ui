import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import '../../components/dui_stepper/DashLineConnector.dart';

enum ConnectorType { solid, dashed }

class ConnectorValue {
  final ConnectorType connectorType;
  final Color? color;
  final double? dash;
  final double? gap;
  final StrokeCap? strokeCap;

  ConnectorValue(
      {required this.connectorType,
      this.color,
      this.dash,
      this.gap,
      this.strokeCap});

  static ConnectorType toConnectorType(dynamic value) {
    switch (value) {
      case 'dashed':
        return ConnectorType.dashed;
      default:
        return ConnectorType.solid;
    }
  }
}

class InternalStepper extends StatefulWidget {
  final int? animationTimeInSeconds;
  final double? completedIndex;
  final ConnectorValue? completedConnector;
  final ConnectorValue? inCompletedConnector;
  final double? indicatorPosition;
  final double? radius;
  final double? thickness;
  final Color? completedColor;
  final Color? inCompletedColor;
  final Widget? completedIcon;
  final Widget? inCompletedIcon;
  final Widget? pendingIcon;
  final int? itemCount;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final List<Widget> children;
  const InternalStepper({
    super.key,
    this.animationTimeInSeconds,
    this.completedIndex,
    this.completedConnector,
    this.inCompletedConnector,
    this.indicatorPosition,
    this.radius,
    this.thickness,
    this.completedColor,
    this.inCompletedColor,
    this.completedIcon,
    this.inCompletedIcon,
    this.pendingIcon,
    this.itemCount,
    this.itemBuilder,
    this.children = const [],
  });

  @override
  State<InternalStepper> createState() => _InternalStepperState();
}

class _InternalStepperState extends State<InternalStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final animationTimeInSeconds = widget.animationTimeInSeconds ?? 0;
    final completedStepIndex = (widget.completedIndex ?? 0.0) - 1.0;

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

  Connector toConnectorType(
      ConnectorValue connectorValue, Color color, double thickness) {
    return switch (connectorValue.connectorType) {
      ConnectorType.solid => Connector.solidLine(
          color: color,
          thickness: thickness,
        ),
      ConnectorType.dashed => CustomDashedLineConnector(
          color: color,
          thickness: thickness,
          dash: connectorValue.dash ?? thickness * 3,
          gap: connectorValue.gap ?? thickness * 2,
          strokeCap: connectorValue.strokeCap ?? StrokeCap.butt,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final indicatorPosition = (widget.indicatorPosition ?? 0.5);
    final radius = widget.radius ?? 28;
    final thickness = widget.thickness ?? 5;
    final completedConnector = widget.completedConnector ??
        ConnectorValue(connectorType: ConnectorType.solid);
    final inCompletedConnector = widget.inCompletedConnector ??
        ConnectorValue(connectorType: ConnectorType.solid);
    final completedIcon = widget.completedIcon;
    final inCompletedIcon = widget.inCompletedIcon;
    final pendingIcon = widget.pendingIcon;

    return Timeline.tileBuilder(
      shrinkWrap: true,
      theme: TimelineThemeData(
        nodePosition: 0,
        indicatorPosition: indicatorPosition,
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.after,
        itemCount: widget.itemCount ?? 0,
        contentsBuilder: (widget.itemBuilder != null)
            ? (ctx, i) => widget.itemBuilder?.call(ctx, i)
            : (context, index) => widget.children[index],
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
                  completedColor: widget.completedColor,
                  inCompletedColor: widget.inCompletedColor,
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
                  ? completedConnector.color ??
                      widget.completedColor ??
                      Colors.blue
                  : inCompletedConnector.color ??
                      widget.inCompletedColor ??
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

Widget _buildIndicator({
  Widget? pendingIcon,
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
      icon = pendingIcon; // Use the pending icon
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
