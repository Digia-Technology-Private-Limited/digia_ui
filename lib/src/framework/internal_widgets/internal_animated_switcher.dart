import 'package:flutter/material.dart';

class InternalAnimatedSwitcher extends StatefulWidget {
  const InternalAnimatedSwitcher({
    super.key,
    this.showFirstChild,
    required this.animationDuration,
    required this.firstChild,
    this.secondChild,
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
  });

  final Widget firstChild;
  final Widget? secondChild;
  final bool? showFirstChild;
  final int animationDuration;
  final Curve switchInCurve;
  final Curve switchOutCurve;

  @override
  State<InternalAnimatedSwitcher> createState() =>
      _InternalAnimatedSwitcherState();
}

class _InternalAnimatedSwitcherState extends State<InternalAnimatedSwitcher> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.animationDuration),
      switchInCurve: widget.switchInCurve,
      switchOutCurve: widget.switchOutCurve,
      child: widget.showFirstChild ?? true
          ? widget.firstChild
          : widget.secondChild ?? widget.firstChild,
    );
  }
}
