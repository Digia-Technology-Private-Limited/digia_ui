import 'dart:async';
import 'package:flutter/material.dart';
import '../base/virtual_stateless_widget.dart';
import '../expr/default_scope_context.dart';
import '../expr/scope_context.dart';
import '../internal_widgets/internal_stream_builder.dart';
import '../render_payload.dart';
import '../utils/functional_util.dart';
import '../widget_props/stream_builder_props.dart';

enum StreamState {
  loading,
  listening,
  completed,
  error;

  String get value => name;
}

class VWStreamBuilder extends VirtualStatelessWidget<StreamBuilderProps> {
  VWStreamBuilder({
    required super.props,
    required super.commonProps,
    super.parentProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  });

  @override
  Widget render(RenderPayload payload) {
    final controller =
        payload.evalExpr(props.controller) as StreamController<Object?>?;

    if (controller == null) return empty();

    final initialData = payload.evalExpr(props.initialData);

    return InternalStreamBuilder(
      controller: controller,
      initialData: initialData,
      builder: (innerCtx, snapshot) {
        final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(snapshot),
            buildContext: innerCtx);

        return child?.toWidget(updatedPayload) ?? empty();
      },
      onSuccess: (context, data) {
        final updatedPayload = payload.copyWithChainedContext(
            _createExprContext(
              AsyncSnapshot.withData(ConnectionState.active, data),
            ),
            buildContext: context);
        updatedPayload.executeAction(
          props.onSuccess,
          triggerType: 'onSuccess',
        );
      },
      onError: (context) {
        final updatedPayload = payload.copyWith(buildContext: context);
        updatedPayload.executeAction(
          props.onError,
          triggerType: 'onError',
        );
      },
    );
  }

  StreamState _getStreamState(AsyncSnapshot<Object?> snapshot) {
    if (snapshot.hasError) {
      return StreamState.error;
    } else if (snapshot.connectionState == ConnectionState.waiting) {
      return StreamState.loading;
    } else if (snapshot.connectionState == ConnectionState.active) {
      return StreamState.listening;
    } else {
      return StreamState.completed;
    }
  }

  ScopeContext _createExprContext(AsyncSnapshot<Object?> snapshot) {
    final StreamState streamState = _getStreamState(snapshot);

    final streamObj = {
      'streamState': streamState.name,
      'streamValue': snapshot.data,
      if (snapshot.hasError) 'error': snapshot.error,
    };

    return DefaultScopeContext(
      variables: {
        ...streamObj,
        ...?refName.maybe((it) => {it: streamObj}),
      },
    );
  }
}
