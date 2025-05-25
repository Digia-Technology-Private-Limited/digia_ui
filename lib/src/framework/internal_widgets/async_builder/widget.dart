import 'package:flutter/material.dart';

import 'controller.dart';

class AsyncBuilder<T> extends StatefulWidget {
  final T? initialData;
  final AsyncController<T>? controller;
  final Future<T> Function()? futureFactory;
  final AsyncWidgetBuilder<T> builder;

  const AsyncBuilder({
    super.key,
    this.initialData,
    this.controller,
    this.futureFactory,
    required this.builder,
  });

  @override
  State<AsyncBuilder> createState() => _AsyncBuilderState<T>();
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
    if ((widget.controller != oldWidget.controller) ||
        // Case where setup is always required.
        (widget.controller == null && oldWidget.controller == null)) {
      _tearDownController();
      _setupController();
    }
    super.didUpdateWidget(oldWidget);
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
      initialData: widget.initialData,
      future: _controller.getFuture(),
      builder: widget.builder,
    );
  }
}
