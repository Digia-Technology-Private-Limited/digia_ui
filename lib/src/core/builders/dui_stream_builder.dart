import 'dart:async';
import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../bracket_scope_provider.dart';
import '../json_widget_builder.dart';
import '../page/dui_page_bloc.dart';
import 'dui_json_widget_builder.dart';

class DUIStreamBuilder extends DUIWidgetBuilder {
  DUIStreamBuilder(
      {required super.data, super.registry = DUIWidgetRegistry.shared});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _makeStream(data.props['streamVariable'], context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return data
                    .getChild('loadingWidget')
                    .let((p0) => DUIWidget(data: p0)) ??
                const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            Future.delayed(const Duration(seconds: 0), () async {
              final actionFlow = ActionFlow.fromJson(data.props['onError']);
              await ActionHandler.instance
                  .execute(context: context, actionFlow: actionFlow);
            });
            return data
                    .getChild('errorWidget')
                    .let((p0) => DUIWidget(data: p0)) ??
                Text(
                  'Error: ${snapshot.error?.toString()}',
                  style: const TextStyle(color: Colors.red),
                );
          }

          if (snapshot.connectionState == ConnectionState.active) {
            Future.delayed(const Duration(seconds: 0), () async {
              final actionFlow = ActionFlow.fromJson(data.props['onSuccess']);
              await ActionHandler.instance.execute(
                  context: context,
                  actionFlow: actionFlow,
                  enclosing:
                      ExprContext(variables: {'response': snapshot.data}));
            });
            return BracketScope(
                variables: [('streamValue', snapshot.data)],
                builder: DUIJsonWidgetBuilder(
                    data: data.getChild('listeningWidget')!,
                    registry: registry!));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return data
                    .getChild('completeWidget')
                    .let((p0) => DUIWidget(data: p0)) ??
                const SizedBox.shrink();
          }

          return const SizedBox.shrink();
        });
  }

  Stream<Object?> _makeStream(
      Map<String, dynamic> stream, BuildContext context) {
    final streamType = stream['type'];
    if (streamType == null) return Stream.error('Stream type not found');

    final streamName = stream['name'];

    final pageArgsMap = context.tryRead<DUIPageBloc>()?.state.pageArgs;
    final pageParaMap = context.tryRead<DUIPageBloc>()?.state.props.inputArgs;

    if (pageArgsMap?[streamName] != pageParaMap?[streamName]) {
      return Stream.error('Stream not found');
    }

    final streamSource = pageArgsMap?[streamName] ?? pageParaMap?[streamName];
    if (streamSource != null) return streamSource as Stream<Object?>;

    return Stream.error('Stream not found');
  }
}
