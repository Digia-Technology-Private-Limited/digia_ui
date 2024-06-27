import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
// import '../../Utils/extensions.dart';
import '../../components/dui_widget.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../json_widget_builder.dart';
// import '../page/dui_page_bloc.dart';

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

          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow = ActionFlow.fromJson(data.props['onSuccess']);
            await ActionHandler.instance
                .execute(context: context, actionFlow: actionFlow);
          });
          // return data
          //         .getChild('successWidget')
          //         .let((p0) => DUIWidget(data: p0)) ??
          //     const SizedBox.shrink();
          return Text('Success: ${snapshot.data}');
        });
  }
}

Stream<Object?> _makeStream(Map<String, dynamic> stream, BuildContext context) {
  final type = stream['streamType'];
  if (type == null) return Stream.error('Type not selected');

  return Stream.periodic(const Duration(seconds: 1), (i) => 20 - i)
      .takeWhile((value) => value >= 0);

  // switch (type) {
  //   case 'timer':

  //     Map<String, dynamic>? timer = context
  //         .read<DUIPageBloc>()
  //         .state
  //         .props
  //         .variables
  //         ?.map((k, v) => MapEntry(k, v.value));
  //     final countType = timer?.valueFor(keyPath: 'countType');
  //     // if (countType == null) {
  //     //   return Stream.error('Count Down/Up not specified');
  //     // }
  //     final updatePageInterval = Duration(
  //         milliseconds: timer?.valueFor(keyPath: 'updatePageInterval') ?? 1000);

  //     switch (countType) {
  //       case 'countDown':
  //         final countDownTime = timer?.valueFor(keyPath: 'countDownTime');
  //         if (countDownTime == null) {
  //           return Stream.error('Count Down Time not specified');
  //         }
  //       // return Stream.periodic(updatePageInterval, (i) => countDownTime - i)
  //       //     .takeWhile((value) => value >= 0);
  //       case 'countUp':
  //         return Stream.periodic(updatePageInterval, (i) => i);
  //     }
  // }

  // return Stream.error('No stream type selected');
}
