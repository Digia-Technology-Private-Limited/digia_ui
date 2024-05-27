import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../config_resolver.dart';
import '../action/action_prop.dart';
import '../action/api_handler.dart';
import '../evaluator.dart';
import '../utils.dart';
import 'dui_page_event.dart';
import 'dui_page_state.dart';
import 'props/dui_page_props.dart';

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
  }

  void _init(
    InitPageEvent event,
    Emitter<DUIPageState> emit,
  ) async {
    // Assumption is that onPageLoadAction will not be null.
    // It will either be Action.loadPage or Action.buildPage
    final onPageLoadAction = state.props.actions['onPageLoad'];

    final action = onPageLoadAction?.actions.first;

    await _handleAction(event.context, action!, emit);

    return;
  }

  void _setState(
    SetStateEvent event,
    Emitter<DUIPageState> emit,
  ) {
    for (final element in event.events) {
      state.props.variables?[element.variableName]?.set(element.value);
    }

    emit(state.copyWith());
  }

// TODO: Need Action Handler
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

      case 'Action.navigateToPage':
        final pageUId = action.data['pageId'];
        return openDUIPage(
            pageUid: pageUId, context: context, pageArgs: action.data['args']);

      case 'Action.openUrl':
        final url = Uri.parse(action.data['url']);
        final canOpenUrl = await canLaunchUrl(url);
        if (canOpenUrl == true) {
          await launchUrl(url,
              mode: DUIDecoder.toUriLaunchMode(action.data['launchMode']));
        }

      case 'Action.pop':
        return Navigator.of(context).maybePop();

      default:
        emit(state.copyWith(isLoading: false));
        return null;
    }
    return null;
  }
}
