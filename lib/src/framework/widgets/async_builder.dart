import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';

import '../../core/action/api_handler.dart';
import '../actions/base/action_flow.dart';
import '../base/virtual_stateless_widget.dart';
import '../internal_widgets/async_builder/controller.dart';
import '../internal_widgets/async_builder/widget.dart';
import '../models/props.dart';
import '../render_payload.dart';

class VWAsyncBuilder extends VirtualStatelessWidget<Props> {
  VWAsyncBuilder({
    required super.props,
    required super.commonProps,
    required super.parent,
    required super.childGroups,
    super.refName,
  }) : super(repeatData: null);

  @override
  Widget render(RenderPayload payload) {
    final successWidget = childOf('successWidget');
    if (successWidget == null) return empty();

    final loadingWidget = childOf('loadingWidget');
    final errorWidget = childOf('errorWidget');

    final futureProps = props.toProps('future');
    if (futureProps == null) return empty();

    return AsyncBuilder<Object?>(
        controller: AsyncController<Object?>(
          futureBuilder: () => _makeFuture(futureProps, payload),
        ),
        builder: (innerCtx, snapshot) {
          final updatedPayload = payload.copyWith(buildContext: innerCtx);

          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingWidget?.toWidget(updatedPayload) ??
                const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            Future.delayed(const Duration(seconds: 0), () async {
              final actionFlow =
                  ActionFlow.fromJson(props.get('postErrorAction'));
              await updatedPayload.executeAction(actionFlow);
            });

            return errorWidget?.toWidget(updatedPayload.copyWithChainedContext(
                  _createExprContext(null, snapshot.error),
                )) ??
                Text(
                  'Error: ${snapshot.error?.toString()}',
                  style: const TextStyle(color: Colors.red),
                );
          }

          Future.delayed(const Duration(seconds: 0), () async {
            final actionFlow =
                ActionFlow.fromJson(props.get('postSuccessAction'));
            await updatedPayload.executeAction(actionFlow);
          });
          return successWidget.toWidget(updatedPayload.copyWithChainedContext(
            _createExprContext(snapshot.data, null),
          ));
        });
  }

  ExprContext _createExprContext(Object? data, Object? error) {
    return ExprContext(variables: {
      'data': data,
      'errorObj': error
      // TODO: Add class instance using refName
    });
  }
}

Future<Object?> _makeFuture(Props futureProps, RenderPayload payload) async {
  final type = futureProps.getString('futureType');
  if (type == null) return Future.error('Type not selected');

  switch (type) {
    case 'api':
      final apiDataSourceId = futureProps.getString('dataSource.id');

      if (apiDataSourceId == null) {
        return Future.error('No API Selected');
      }

      Map<String, Object?>? apiDataSourceArgs =
          futureProps.getMap('dataSource.args');

      final apiModel = payload.getApiModel(apiDataSourceId);

      if (apiModel == null) {
        return Future.error('No API Selected');
      }

      final args = apiDataSourceArgs?.map((key, value) {
        final evalue = payload.eval(value);
        final dvalue = apiModel.variables?[key]?.defaultValue;
        return MapEntry(key, evalue ?? dvalue);
      });

      return ApiHandler.instance.execute(apiModel: apiModel, args: args).then(
          (value) {
        final successAction = ActionFlow.fromJson(futureProps.get('onSuccess'));
        return payload.executeAction(
          successAction,
          exprContext: ExprContext(variables: {'response': value.data}),
        );
      }, onError: (e) async {
        final errorAction = ActionFlow.fromJson(futureProps.get('onFailure'));
        await payload.executeAction(
          errorAction,
          exprContext: ExprContext(variables: {'error': e}),
        );
        throw e;
      });

    case 'delay':
      return Future.delayed(
          Duration(milliseconds: futureProps.getInt('durationInMs') ?? 0));
  }
  return Future.error('No future type selected.');
}
