import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWStreamBuilder extends VirtualStatelessWidget<Props> {
  VWStreamBuilder({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final streamDef = props.toProps('streamVariable');
    if (streamDef == null) return empty();

    return StreamBuilder(
      stream: _makeStream(streamDef, payload),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return childOf('loadingWidget')?.toWidget(payload) ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow = ActionFlow.fromJson(props.get('onError'));
            await payload.executeAction(actionFlow);
          });
          return childOf('errorWidget')?.toWidget(payload) ??
              Text(
                'Error: ${snapshot.error?.toString()}',
                style: const TextStyle(color: Colors.red),
              );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow = ActionFlow.fromJson(props.get('onSuccess'));
            await payload.executeAction(actionFlow);
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

  // TODO: Check if this will work.
  Stream<Object?> _makeStream(Props stream, RenderPayload payload) {
    final streamName = stream.getString('name');
    if (streamName == null) {
      return Stream.error('No source provided');
    }
    final streamSource = payload.eval('\${params.$streamName}');
    if (streamSource != null) return streamSource as Stream<Object?>;
    return Stream.error('Stream not found');
  }

  ExprContext _createExprContext(Object? streamValue) {
    return ExprContext(variables: {
      'streamValue': streamValue,
    });
  }
}
