import 'package:flutter/widgets.dart';

import 'controller.dart';

class TimerWidget extends StatefulWidget {
  final TimerController controller;
  final AsyncWidgetBuilder<int> builder;
  const TimerWidget({
    super.key,
    required this.controller,
    required this.builder,
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

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _setupController();
    }
  }

  void _setupController() {
    _controller = widget.controller;
    _controller.start();
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
