import 'dart:async';
import 'package:flutter/material.dart';

class InternalStreamBuilder extends StatefulWidget {
  final StreamController<Object?> controller;
  final Object? initialData;
  final Widget Function(BuildContext, AsyncSnapshot<Object?>) builder;
  final void Function(BuildContext context, Object? data)? onSuccess;
  final void Function(BuildContext context)? onError;

  const InternalStreamBuilder({
    super.key,
    required this.controller,
    this.initialData,
    required this.builder,
    this.onSuccess,
    this.onError,
  });

  @override
  State<InternalStreamBuilder> createState() => _InternalStreamBuilderState();
}

class _InternalStreamBuilderState extends State<InternalStreamBuilder> {
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant InternalStreamBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.controller, widget.controller)) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    _subscription = widget.controller.stream.listen(
      (data) {
        if (mounted) {
          widget.onSuccess?.call(context, data);
        }
      },
      onError: (Object error, StackTrace stack) {
        if (mounted) {
          widget.onError?.call(context);
        }
      },
    );
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: widget.controller.stream,
      initialData: widget.initialData,
      builder: widget.builder,
    );
  }
}
