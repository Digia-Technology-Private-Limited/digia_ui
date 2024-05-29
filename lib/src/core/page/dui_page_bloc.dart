import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../digia_ui.dart';
import '../../Utils/expr.dart';
import '../action/action_prop.dart';
import '../action/api_handler.dart';
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
            props: config.getPageData(pageUid))) {
    on<InitPageEvent>(_init);
    on<SetStateEvent>(_setState);
    on<RebuildPageEvent>(_rebuildPage);
  }

  void _init(
    InitPageEvent event,
    Emitter<DUIPageState> emit,
  ) async {
    // Assumption is that onPageLoadAction will not be null.
    // It will either be Action.loadPage or Action.buildPage
    
    final onPageLoadAction = state.props.actions['onPageLoad'];

    var eventData = evalDynamic(onPageLoadAction?.analyticsData, event.context, null); 
    if(eventData != null && (eventData as Map<String, dynamic>).isNotEmpty) {
      DigiaUIClient.instance.duiAnalytics?.onEvent(eventData);
    }
    
    final action = onPageLoadAction?.actions.first;

    await _handleAction(event.context, action!, emit);

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
        final response =
            await ApiHandler.instance.execute(apiModel: apiModel, args: args);

        emit(state.copyWith(isLoading: false, dataSource: response));
        return null;

      default:
        emit(state.copyWith(isLoading: false));
        return null;
    }
  }
}
