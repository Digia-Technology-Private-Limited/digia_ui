import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import '../../Utils/extensions.dart';
import '../../core/action/action_handler.dart';
import '../../core/action/action_prop.dart';
import '../../core/page/dui_page_bloc.dart';
import '../core/extensions.dart';
import '../core/virtual_stateless_widget.dart';
import '../render_payload.dart';

class VWStreamBuilder extends VirtualStatelessWidget {
  VWStreamBuilder({
    required super.props,
    required super.commonProps,
    required super.childGroups,
    required super.parent,
    super.refName,
    required super.repeatData,
  });

  @override
  Widget render(RenderPayload payload) {
    return StreamBuilder(
      stream: _makeStream(props['streamVariable'], payload),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return childOf('loadingWidget')?.toWidget(payload) ??
              const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow = ActionFlow.fromJson(props['onError']);
            await ActionHandler.instance
                .execute(context: context, actionFlow: actionFlow);
          });
          return childOf('errorWidget')?.toWidget(payload) ??
              Text(
                'Error: ${snapshot.error?.toString()}',
                style: const TextStyle(color: Colors.red),
              );
        }

        if (snapshot.connectionState == ConnectionState.active) {
          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow = ActionFlow.fromJson(props['onSuccess']);
            await ActionHandler.instance.execute(
                context: context,
                actionFlow: actionFlow,
                enclosing: _createExprContext(snapshot.data, null));
          });
          return childOf('listeningWidget')!.toWidget(
            payload.copyWithChainedContext(
              _createExprContext(null, snapshot.data),
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

  Stream<Object?> _makeStream(
      Map<String, dynamic> stream, RenderPayload payload) {
    final streamName = stream['name'];
    final pageArgsMap =
        payload.buildContext.tryRead<DUIPageBloc>()?.state.pageArgs;
    final streamSource = pageArgsMap?[streamName];
    if (streamSource != null) return streamSource as Stream<Object?>;
    return Stream.error('Stream not found');
  }

  ExprContext _createExprContext(Object? response, Object? streamValue) {
    return ExprContext(variables: {
      'response': response,
      'streamValue': streamValue,
    });
  }
}
