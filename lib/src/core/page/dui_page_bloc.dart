import 'dart:async';

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
    on<PageLoadedEvent>(_pageLoaded);
    on<BackPressEvent>(_backPressed);
  }

  void register(String widgetName, Map<String, Function> getters) {
    state.widgetVars[widgetName] = getters;
  }

  void _init(
    InitPageEvent blocEvent,
    Emitter<DUIPageState> emit,
  ) async {
    final pageStates = state.props.variables;
    if (pageStates != null) {
      for (final element in pageStates.entries) {
        final pageStateDefaultValue = element.value.value;
        final evaluatedValue = evalDynamic(pageStateDefaultValue,
            blocEvent.context, ExprContext(variables: {}));
        state.props.variables?[element.key]?.set(evaluatedValue);
      }
    }

    // Assumption is that executeDataSourceAction will not be null.
    // It will either be Action.loadPage or Action.buildPage
    final executeDataSourceAction = state.props.executeDataSource;
    AnalyticsHandler.instance.execute(
        context: blocEvent.context,
        events: executeDataSourceAction?.analyticsData);

    final action = executeDataSourceAction?.actions.firstOrNull;

    if (action != null && action.type == 'Action.loadPage') {
      await _executeDataSource(blocEvent.context, action, emit);
    } else {
      emit(state.copyWith(isLoading: false));
    }

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

  Future<void> _executeDataSource(BuildContext context, ActionProp action,
      Emitter<DUIPageState> emit) async {
    emit(state.copyWith(isLoading: true));
    final apiDataSourceId = action.data['dataSourceId'];
    Map<String, dynamic>? apiDataSourceArgs = action.data['args'];

    final apiModel = config.getApiDataSource(apiDataSourceId);

    final args = apiDataSourceArgs
        ?.map((key, value) => MapEntry(key, eval(value, context: context)));

    try {
      final resp =
          await ApiHandler.instance.execute(apiModel: apiModel, args: args);

      final respObj = {
        'body': resp.data,
        'statusCode': resp.statusCode,
        'headers': resp.headers,
        'requestObj': requestObjToMap(resp.requestOptions),
        'error': null,
      };

      if (!context.mounted) {
        emit(state.copyWith(isLoading: false, dataSource: resp.data));
        return;
      }

      if (_isSuccess(
          context, action.data['successCondition'] as String?, respObj)) {
        final successAction = ActionFlow.fromJson(action.data['onSuccess']);
        await ActionHandler.instance.execute(
            context: context,
            actionFlow: successAction,
            enclosing: ExprContext(variables: {'response': respObj}));
      } else {
        final errorAction = ActionFlow.fromJson(action.data['onError']);
        await ActionHandler.instance.execute(
            context: context,
            actionFlow: errorAction,
            enclosing: ExprContext(variables: {'response': respObj}));
      }

      emit(state.copyWith(isLoading: false, dataSource: resp.data));
    } catch (e) {
      final res = {
        'error': e,
      };

      if (!context.mounted) {
        emit(state.copyWith(isLoading: false, dataSource: null));
        return;
      }

      final errorAction = ActionFlow.fromJson(action.data['onError']);
      await ActionHandler.instance.execute(
          context: context,
          actionFlow: errorAction,
          enclosing: ExprContext(variables: {'response': res}));
    }
  }

  bool _isSuccess(
      BuildContext context, String? successCondition, Object response) {
    return successCondition?.let((p0) => eval<bool>(successCondition,
            context: context,
            enclosing: ExprContext(
              variables: {'response': response},
            ))) ??
        successCondition == null || successCondition.isEmpty;
  }

  FutureOr<void> _pageLoaded(
      PageLoadedEvent event, Emitter<DUIPageState> emit) {
    final pageLoadActionFlow = state.props.onPageLoad;
    if (pageLoadActionFlow != null) {
      ActionHandler.instance
          .execute(context: event.context, actionFlow: pageLoadActionFlow);
    }
  }

  FutureOr<void> _backPressed(
      BackPressEvent event, Emitter<DUIPageState> emit) {
    final actionFlow = state.props.onBackPress;
    if (actionFlow != null) {
      ActionHandler.instance
          .execute(context: event.context, actionFlow: actionFlow);
    }
  }
}
