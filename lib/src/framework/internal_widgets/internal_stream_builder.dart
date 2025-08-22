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
  late final Stream<Object?> _broadcastStream;
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    _broadcastStream = widget.controller.stream.asBroadcastStream();

    _subscription = _broadcastStream.listen(
      (data) {
        if (mounted) {
          widget.onSuccess?.call(context, data);
        }
      },
      onError: (_) {
        if (mounted) {
          widget.onError?.call(context);
        }
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object?>(
      stream: _broadcastStream,
      initialData: widget.initialData,
      builder: widget.builder,
    );
  }
}
