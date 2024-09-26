import 'package:flutter/material.dart';

import 'controller.dart';

class AsyncBuilder<T> extends StatefulWidget {
  final AsyncController<T> controller;
  final AsyncWidgetBuilder<T> builder;

  const AsyncBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  _AsyncBuilderState<T> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  late AsyncController<T> _controller;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didUpdateWidget(AsyncBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _setupController();
    }
  }

  void _setupController() {
    _controller = widget.controller;
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _controller.future,
      builder: widget.builder,
    );
  }
}
