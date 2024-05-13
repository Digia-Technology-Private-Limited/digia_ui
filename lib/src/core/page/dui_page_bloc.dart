import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:digia_ui/src/core/action/post_action.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:digia_ui/src/core/page/props/dui_page_props.dart';
import 'package:digia_ui/src/core/utils.dart';
import 'package:digia_ui/src/network/api_request/api_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../config_resolver.dart';

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

    final action = ActionProp.fromJson(onPageLoadAction);
    // final apiDataMap = _config.getAPIData(state.pageUid);
    // final apiData = APIModel.fromJson(apiDataMap as Map<String, dynamic>? ?? {});
    // final api = APICall(_config).execute(action, apiData);

    action.data['pageParams'] = {
      ...?action.data['pageParams'],
      ...?event.pageParams,
    };

    await _handleAction(null, action, emit);

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
        final pagePropsJson = await APICall(_config).execute(action.data);

        // if (pagePropsJson == null) {
        //   throw 'API Call failed for Page: ${state.pageUid}';
        // }

        final props = DUIPageProps.fromJson(pagePropsJson['data']['response']);
        emit(state.copyWith(isLoading: false, props: props));
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
    if (action.data.isNotEmpty) {
      final resp = await APICall(_config).execute(action.data);
      // final props = DUIPageProps.fromJson(pagePropsJson['response']);
      // emit(state.copyWith(isLoading: false, props: props));
      return resp;
    }
    return null;
  }
}
