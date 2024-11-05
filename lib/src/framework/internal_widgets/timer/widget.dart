import 'package:flutter/widgets.dart';

import 'controller.dart';

class TimerWidget extends StatefulWidget {
  final TimerController? controller;
  final AsyncWidgetBuilder<int> builder;
  final int initialValue;
  final Duration updateInterval;
  final bool isCountDown;
  final int duration;

  const TimerWidget({
    super.key,
    this.controller,
    required this.builder,
    this.initialValue = 0,
    this.updateInterval = const Duration(seconds: 1),
    this.isCountDown = false,
    this.duration = 60,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late TimerController _controller;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    _controller = widget.controller ??
        TimerController(
          initialValue: widget.initialValue,
          updateInterval: widget.updateInterval,
          isCountDown: widget.isCountDown,
          duration: widget.duration,
        );
    _controller.start();
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller ||
        widget.initialValue != oldWidget.initialValue ||
        widget.updateInterval != oldWidget.updateInterval ||
        widget.isCountDown != oldWidget.isCountDown ||
        widget.duration != oldWidget.duration) {
      // Its ok to dispose this. If it was a ChangeNotifier, then removeListener
      // should be called.
      _controller.dispose();
      _setupController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      initialData: _controller.currentValue,
      stream: _controller.stream,
      builder: widget.builder,
    );
  }
}
