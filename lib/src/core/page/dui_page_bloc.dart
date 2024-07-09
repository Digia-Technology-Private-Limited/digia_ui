import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../digia_ui.dart';
import '../../Utils/basic_shared_utils/lodash.dart';
import '../../Utils/expr.dart';
import '../action/action_handler.dart';
import '../action/action_prop.dart';
import '../action/api_handler.dart';
import '../analytics_handler.dart';
import '../evaluator.dart';
import 'dui_page_event.dart';
import 'dui_page_state.dart';

class DUIPageBloc extends Bloc<DUIPageEvent, DUIPageState> {
  final DUIConfig config;

  DUIPageBloc({
    required String pageUid,
    required this.config,
    Map<String, dynamic>? pageArgs,
  }) : super(DUIPageState(
            pageUid: pageUid,
            isLoading: true,
            pageArgs: pageArgs,
            props: config.getPageData(pageUid),
            widgetVars: {})) {
    on<InitPageEvent>(_init);
    on<SetStateEvent>(_setState);
    on<RebuildPageEvent>(_rebuildPage);
  }

  void register(String widgetName, Map<String, Function> getters) {
    state.widgetVars[widgetName] = getters;
  }

  void _init(
    InitPageEvent blocEvent,
    Emitter<DUIPageState> emit,
  ) async {
    // Assumption is that onPageLoadAction will not be null.
    // It will either be Action.loadPage or Action.buildPage

    final pageStates = state.props.variables;
    if (pageStates != null) {
      for (final element in pageStates.entries) {
        final pageStateDefaultValue = element.value.value;
        final evaluatedValue = evalDynamic(pageStateDefaultValue,
            blocEvent.context, ExprContext(variables: {}));
        state.props.variables?[element.key]?.set(evaluatedValue);
      }
    }

    final onPageLoadAction = state.props.actions['onPageLoad'];

    AnalyticsHandler.instance.execute(
        context: blocEvent.context, events: onPageLoadAction?.analyticsData);

    final action = onPageLoadAction?.actions.first;

    await _handleAction(blocEvent.context, action!, emit);

    return;
  }

  void _rebuildPage(RebuildPageEvent event, Emitter<DUIPageState> emit) {
    emit(state.copyWith());
  }

  void _setState(
    SetStateEvent event,
    Emitter<DUIPageState> emit,
  ) {
    for (final element in event.events) {
      state.props.variables?[element.variableName]?.set(element.value);
    }

    if (event.rebuildPage) {
      emit(state.copyWith());
    }
  }

  Future<Object?> _handleAction(BuildContext context, ActionProp action,
      Emitter<DUIPageState> emit) async {
    switch (action.type) {
      case 'Action.loadPage':
        emit(state.copyWith(isLoading: true));
        final apiDataSourceId = action.data['dataSourceId'];
        Map<String, dynamic>? apiDataSourceArgs = action.data['args'];

        final apiModel = config.getApiDataSource(apiDataSourceId);

        final args = apiDataSourceArgs
            ?.map((key, value) => MapEntry(key, eval(value, context: context)));
        final response = await ApiHandler.instance
            .execute(apiModel: apiModel, args: args)
            .then((resp) async {
          final res = {
            'body': resp.data,
            'statusCode': resp.statusCode,
            'headers': resp.headers,
            'requestObj': requestObjToMap(resp.requestOptions),
            'error': null,
          };

          final successCondition = action.data['successCondition'] as String?;
          final evaluatedSuccessCond =
              successCondition?.let((p0) => eval<bool>(successCondition,
                      context: context,
                      enclosing: ExprContext(
                        variables: {'response': res},
                      ))) ??
                  successCondition == null || successCondition.isEmpty;

          if (evaluatedSuccessCond) {
            final successAction = ActionFlow.fromJson(action.data['onSuccess']);
            await ActionHandler.instance.execute(
                context: context,
                actionFlow: successAction,
                enclosing: ExprContext(variables: {'response': res}));
          } else {
            final errorAction = ActionFlow.fromJson(action.data['onError']);
            await ActionHandler.instance.execute(
                context: context,
                actionFlow: errorAction,
                enclosing: ExprContext(variables: {'response': res}));
          }
        }, onError: (e) async {
          final errorAction = ActionFlow.fromJson(action.data['onError']);

          final res = {
            'body': e.response.data,
            'statusCode': e.response.statusCode,
            'headers': e.response.headers,
            'requestObj': requestObjToMap(e.requestOptions),
            'error': e.message,
          };

          await ActionHandler.instance.execute(
              context: context,
              actionFlow: errorAction,
              enclosing: ExprContext(variables: {'response': res}));

          final postErrorAction = ActionFlow.fromJson(action.data['postError']);
          return ActionHandler.instance.execute(
              context: context,
              actionFlow: postErrorAction,
              enclosing: ExprContext(variables: {'response': res}));
        });

        final postSuccessAction =
            ActionFlow.fromJson(action.data['postSuccess']);
        await ActionHandler.instance
            .execute(context: context, actionFlow: postSuccessAction);

        if (response == null) {
          final postErrorAction = ActionFlow.fromJson(action.data['postError']);
          await ActionHandler.instance
              .execute(context: context, actionFlow: postErrorAction);
        }

        emit(state.copyWith(isLoading: false, dataSource: response));
        return null;

      default:
        emit(state.copyWith(isLoading: false));
        return null;
    }
  }
}
