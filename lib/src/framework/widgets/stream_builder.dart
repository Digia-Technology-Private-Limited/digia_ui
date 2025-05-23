import 'dart:async';
import 'package:flutter/material.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_stream_builder.dart';
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
    final controller =
        payload.evalExpr(props.controller) as StreamController<Object?>?;

    if (controller == null) return empty();

    final initialData = payload.evalExpr(props.initialData);

    return InternalStreamBuilder(
      controller: controller,
      initialData: initialData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return childOf('loadingWidget')?.toWidget(payload) ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          return childOf('errorWidget')?.toWidget(payload) ??
              Text(
                'Error: ${snapshot.error?.toString()}',
                style: const TextStyle(color: Colors.red),
              );
        }

        if (snapshot.connectionState == ConnectionState.active) {
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
      onSuccess: (context, data) {
        final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(data),
            buildContext: context);
        updatedPayload.executeAction(props.onSuccess);
      },
      onError: (context) {
        final updatedPayload = payload.copyWith(buildContext: context);
        updatedPayload.executeAction(props.onError);
      },
    );
  }

  ScopeContext _createExprContext(Object? streamValue) {
    return DefaultScopeContext(variables: {
      'streamValue': streamValue,
    });
  }
}
