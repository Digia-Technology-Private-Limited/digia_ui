import 'package:flutter/material.dart';

import 'controller.dart';

class AsyncBuilder<T> extends StatefulWidget {
  final AsyncController<T>? controller;
  final Future<T>? future;
  final AsyncWidgetBuilder<T> builder;

  const AsyncBuilder._({
    super.key,
    this.controller,
    this.future,
    required this.builder,
  });

  const AsyncBuilder.withController({
    Key? key,
    required AsyncController<T> controller,
    required AsyncWidgetBuilder<T> builder,
  }) : this._(
          key: key,
          controller: controller,
          builder: builder,
        );

  const AsyncBuilder.withFuture({
    Key? key,
    required Future<T> future,
    required AsyncWidgetBuilder<T> builder,
  }) : this._(
          key: key,
          future: future,
          builder: builder,
        );

  @override
  _AsyncBuilderState<T> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  late AsyncController<T> _controller;
  bool _isLocalController = false;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  @override
  void didUpdateWidget(AsyncBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.future != oldWidget.future) {
      _disposeLocalController();
      _setupController();
    }
  }

  void _setupController() {
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isLocalController = false;
    } else {
      _controller = AsyncController<T>(futureBuilder: () => widget.future!);
      _isLocalController = true;
    }
    _controller.addListener(_rebuild);
  }

  void _disposeLocalController() {
    if (_isLocalController) {
      _controller.removeListener(_rebuild);
      _controller.dispose();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_rebuild);
    _disposeLocalController();
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
