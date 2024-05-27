import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/dui_widget_registry.dart';
import '../../Utils/extensions.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../action/api_handler.dart';
import '../evaluator.dart';
import '../json_widget_builder.dart';
import '../page/dui_page_bloc.dart';

class DUIFutureBuilder extends DUIWidgetBuilder {
  DUIFutureBuilder(
      {required super.data, super.registry = DUIWidgetRegistry.shared});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _makeFuture(data.props['future'], context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return data
                    .getChild('loadingWidget')
                    .let((p0) => DUIWidget(data: p0)) ??
                const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return data
                    .getChild('errorWidget')
                    .let((p0) => DUIWidget(data: p0)) ??
                Text('Error: ${snapshot.error}');
          }

          return data
                  .getChild('successWidget')
                  .let((p0) => DUIWidget(data: p0)) ??
              const SizedBox.shrink();
        });
  }
}

Future<Object?> _makeFuture(
    Map<String, dynamic> future, BuildContext context) async {
  final type = future['futureType'];
  if (type == null) return Future.error('Type not selected');

  switch (type) {
    case 'api':
      final apiDataSourceId = future.valueFor(keyPath: 'dataSource.id');
      Map<String, dynamic>? apiDataSourceArgs =
          future.valueFor(keyPath: 'dataSource.args');

      final apiModel = (context.tryRead<DUIPageBloc>()?.config ??
              DigiaUIClient.getConfigResolver())
          .getApiDataSource(apiDataSourceId);

      final args = apiDataSourceArgs
          ?.map((key, value) => MapEntry(key, eval(value, context: context)));

      return ApiHandler.instance.execute(apiModel: apiModel, args: args).then(
          (value) {
        final successAction =
            ActionFlow.fromJson(future.valueFor(keyPath: 'onSuccess'));
        return ActionHandler.instance.execute(
            context: context,
            actionFlow: successAction,
            enclosing: ExprContext(variables: {'response': value}));
      }, onError: (e) async {
        final errorAction =
            ActionFlow.fromJson(future.valueFor(keyPath: 'onError'));
        await ActionHandler.instance.execute(
            context: context,
            actionFlow: errorAction,
            enclosing: ExprContext(variables: {'error': e}));
      });

    case 'delay':
      return Future.delayed(Duration(milliseconds: future['durationInMs']));
  }
  return Future.error('No future type selected.');
}
