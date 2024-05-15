import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../config_resolver.dart';
import '../../network/api_request/api_request.dart';
import '../action/action_prop.dart';
import '../action/post_action.dart';
import '../utils.dart';
import 'dui_page_event.dart';
import 'dui_page_state.dart';
import 'props/dui_page_props.dart';

/// Usecases:
/// 1. Static Pages
/// 2. Data Driven Pages
///
/// Questions to Answer:
/// 1. How to figure out if a page is Static or Data Driven
/// 2. if  Data Driven
///   2.a: how to access the data post availability. ex: dataSource.jokeName

class DUIPageBloc extends Bloc<DUIPageEvent, DUIPageState> {
  final DUIConfig _config;
  final Function(String methodId, Map<String, dynamic>? data)?
      onExternalMethodCalled;

  DUIPageBloc({
    required String pageUid,
    required DUIConfig config,
    this.onExternalMethodCalled,
  })  : _config = config,
        super(DUIPageState(
            pageUid: pageUid,
            isLoading: true,
            props: config.getPageData(pageUid))) {
    on<InitPageEvent>(_init);
    on<SetStateEvent>(_setState);
    // on<PostActionEvent>(
    //     (event, emit) => _handleAction(event.context, event.action, emit));
  }

  void _init(
    InitPageEvent event,
    Emitter<DUIPageState> emit,
  ) async {
    // Assumption is that onPageLoadAction will not be null.
    // It will either be Action.loadPage or Action.buildPage
    final onPageLoadAction = state.props.actions['onPageLoad'];

    final action = onPageLoadAction?.actions.first;

    action?.data['pageParams'] = {
      ...?action.data['pageParams'],
      ...?event.pageParams,
    };

    await _handleAction(null, action!, emit);

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
  Future<Object?> _handleAction(BuildContext? context, ActionProp action,
      Emitter<DUIPageState> emit) async {
    switch (action.type) {
      // TODO: Move to some constant
      case 'Action.loadPage':
        emit(state.copyWith(isLoading: true));
        final apiMap = _config.getAPIData();
        final actionDataSourceMap = action.data;
        final dataSourceId = actionDataSourceMap['dataSourceId'];
        final variablesMap = actionDataSourceMap['variables'];
        final apiResponseData =
            await APICall(_config).execute(dataSourceId, apiMap!, variablesMap);

        emit(state.copyWith(isLoading: false, dataSource: apiResponseData));
        return null;

      case 'Action.rebuildPage':
        emit(state.copyWith(isLoading: true));
        final pagePropsJson = await PostAction(_config).execute(action);

        if (pagePropsJson == null) {
          throw 'Props not found for Page: ${state.pageUid}';
        }

        final props = DUIPageProps.fromJson(pagePropsJson['response']);
        emit(state.copyWith(isLoading: false, props: props));
        return null;

      case 'Action.navigateToPage':
        final pageUId = action.data['pageId'];
        return openDUIPage(
            pageUid: pageUId, context: context!, pageArgs: action.data['args']);

      case 'Action.openUrl':
        final url = Uri.parse(action.data['url']);
        final canOpenUrl = await canLaunchUrl(url);
        if (canOpenUrl == true) {
          await launchUrl(url,
              mode: DUIDecoder.toUriLaunchMode(action.data['launchMode']));
        }

      case 'Action.pop':
        if (context != null) {
          return Navigator.of(context).maybePop();
        }

      case 'Action.callExternalMethod':
        onExternalMethodCalled?.call(
            action.data['methodId'] ?? '', action.data['args']);

      default:
        emit(state.copyWith(isLoading: false));
        return null;
    }
    return null;
  }
}
