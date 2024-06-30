import 'dart:async';
import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/basic_shared_utils/num_decoder.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../../components/dui_widget.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../async_data_provider.dart';
import '../json_widget_builder.dart';
import '../page/dui_page_bloc.dart';
import 'dui_json_widget_builder.dart';

class DUIStreamBuilder extends DUIWidgetBuilder {
  DUIStreamBuilder(
      {required super.data, super.registry = DUIWidgetRegistry.shared});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _makeStream(data.props['stream'], context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return data
                    .getChild('loadingWidget')
                    .let((p0) => DUIWidget(data: p0)) ??
                const Center(child: CircularProgressIndicator());
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
                // enclosing: ExprContext(
                //   variables: {'response': snapshot.data},
                // ),
              );
            });
            return AsyncDataProvider(
                data: snapshot.data,
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
}

Stream<Object?> _makeStream(Map<String, dynamic> stream, BuildContext context) {
  final type = stream['streamType'];
  if (type == null) return Stream.error('Type not selected');

  final onSuccessAction =
      ActionFlow.fromJson(stream.valueFor(keyPath: 'onSuccess'));
  final onErrorAction =
      ActionFlow.fromJson(stream.valueFor(keyPath: 'onError'));

  // final config = stream['streamVar'];
  // final timerType = config?.valueFor(keyPath: 'timerType');
  // final pageUpdateInterval = Duration(
  //     seconds: NumDecoder.toIntOrDefault(
  //         config?.valueFor(keyPath: 'pageUpdateInterval'),
  //         defaultValue: 1000));
  // final countDownValue = NumDecoder.toIntOrDefault(
  //     config?.valueFor(keyPath: 'countDownValue'),
  //     defaultValue: 20);

  switch (type) {
    case 'timer':
      final pageStates = context.read<DUIPageBloc>().state.props.variables;
      final timer =
          pageStates?.values.firstWhere((element) => element.type == 'timer');
      final timerConfig = timer?.defaultValue as Map<String, dynamic>?;

      final timerType = timerConfig?.valueFor(keyPath: 'timerType');

      final pageUpdateInterval = Duration(
          seconds: NumDecoder.toIntOrDefault(
              timerConfig?.valueFor(keyPath: 'pageUpdateInterval'),
              defaultValue: 1000));

      switch (timerType) {
        case 'countDown':
          final countDownValue = NumDecoder.toIntOrDefault(
              timerConfig?.valueFor(keyPath: 'countDownValue'),
              defaultValue: 20);
          Stream<int> s;
          s = Stream.periodic(pageUpdateInterval, (i) => countDownValue - i)
              .takeWhile((value) => value >= 0);

          return s.transform(StreamTransformer<int, Object?>.fromHandlers(
            handleData: (data, sink) {
              ActionHandler.instance.execute(
                  context: context,
                  actionFlow: onSuccessAction,
                  enclosing: ExprContext(variables: {'response': data}));
              sink.add(data);
            },
            handleError: (error, stackTrace, sink) {
              ActionHandler.instance.execute(
                  context: context,
                  actionFlow: onErrorAction,
                  enclosing: ExprContext(variables: {'error': error}));
              sink.addError(error, stackTrace);
            },
          ));

        case 'countUp':
          return Stream.periodic(pageUpdateInterval, (i) => i);
      }
  }

  return Stream.error('No stream type selected');
}
