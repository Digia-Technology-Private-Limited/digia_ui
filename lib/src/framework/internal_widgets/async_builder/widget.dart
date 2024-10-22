import 'package:flutter/material.dart';

import 'controller.dart';

class AsyncBuilder<T> extends StatefulWidget {
  final AsyncController<T>? controller;
  final Future<T> Function()? futureFactory;
  final AsyncWidgetBuilder<T> builder;

  const AsyncBuilder({
    super.key,
    this.controller,
    this.futureFactory,
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
    if (widget.controller != oldWidget.controller ||
        widget.futureFactory != oldWidget.futureFactory) {
      _tearDownController();
      _setupController();
    }
  }

  void _setupController() {
    _controller = widget.controller ??
        AsyncController<T>(futureCreator: widget.futureFactory);
    _controller.addListener(_rebuild);
  }

  void _tearDownController() {
    _controller.removeListener(_rebuild);
  }

  @override
  void dispose() {
    _tearDownController();
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: _controller.getFuture(),
      builder: widget.builder,
    );
  }
}
