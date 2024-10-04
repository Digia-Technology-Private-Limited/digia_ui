import 'dart:async';

import 'package:flutter/material.dart';

import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../render_payload.dart';
import '../widget_props/stream_builder_props.dart';

class VWStreamBuilder extends VirtualStatelessWidget<StreamBuilderProps> {
  VWStreamBuilder({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final streamDef = payload.evalExpr(props.streamRef);
    if (streamDef == null) return empty();

    return StreamBuilder(
      stream: _makeStream(streamDef).stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return childOf('loadingWidget')?.toWidget(payload) ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          Future.delayed(const Duration(seconds: 0), () async {
            await payload.executeAction(props.onError);
          });
          return childOf('errorWidget')?.toWidget(payload) ??
              Text(
                'Error: ${snapshot.error?.toString()}',
                style: const TextStyle(color: Colors.red),
              );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          Future.delayed(const Duration(seconds: 0), () async {
            await payload.executeAction(props.onSuccess);
          });
          return childOf('listeningWidget')!.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(snapshot.data),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return childOf('completeWidget')?.toWidget(payload) ?? empty();
        }

        return empty();
      },
    );
  }

  // StreamController<Object?> _makeStream(Object? stream) {
  //   if (stream is Stream<Object>) {
  //     return StreamController<Object>()..addStream(stream);
  //   }

  //   if (stream is StreamController<Object>) {
  //     return stream;
  //   }

  //   return StreamController<Object>()
  //     ..addStream(Stream.error('No Stream provided'));
  // }
  StreamController<Object?> _makeStream(Object? stream) {
    if (stream is Stream<Object?>) {
      // Create a new StreamController and add the stream to it.
      final controller = StreamController<Object?>();
      controller.addStream(stream);
      return controller;
    }

    if (stream is Stream<Object>) {
      // Create a new StreamController and add the stream to it, mapping it to Object? type.
      final controller = StreamController<Object?>();
      controller.addStream(stream.map((event) => event as Object?));
      return controller;
    }

    if (stream is StreamController<Object?>) {
      // If the input is already a StreamController<Object?>, return it directly.
      return stream;
    }

    if (stream is StreamController<Object>) {
      // If the input is a StreamController<Object>, cast it to StreamController<Object?>.
      return stream as StreamController<Object?>;
    }

    // Return a new StreamController with an error stream if no valid input is provided.
    final controller = StreamController<Object?>();
    controller.addStream(Stream.error('No Stream provided'));
    return controller;
  }

  ScopeContext _createExprContext(Object? streamValue) {
    return DefaultScopeContext(variables: {
      'streamValue': streamValue,
    });
  }
}
