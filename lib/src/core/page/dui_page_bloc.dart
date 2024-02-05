import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:digia_ui/src/core/action/post_action.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:digia_ui/src/core/page/props/dui_page_props.dart';
import 'package:digia_ui/src/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';
import '../../config_resolver.dart';

class DUIPageBloc extends Bloc<DUIPageEvent, DUIPageState> {
  final DigiaUIConfigResolver resolver;
  final Map<String, dynamic>? args;

  DUIPageBloc(
      {required DUIPageInitData initData, required this.resolver, this.args})
      : super(DUIPageState(
            uid: initData.identifier,
            isLoading: true,
            props: DUIPageProps.fromJson(initData.config))) {
    on<InitPageEvent>(_init);
    on<PostActionEvent>(
        (event, emit) => _handleAction(event.context, event.action, emit));
  }

  void _init(
    InitPageEvent event,
    Emitter<DUIPageState> emit,
  ) async {
    // Assumption is that onPageLoadAction will not be null.
    // It will either be Action.loadPage or Action.buildPage
    final onPageLoadAction = state.props?.actions['onPageLoad'];

    final action = ActionProp.fromJson(onPageLoadAction);

    action.data['pageParams'] = {
      ...?action.data['pageParams'],
      ...?event.pageParams,
    };

    await _handleAction(null, action, emit);

    return;
  }

// TODO: Need Action Handler
  Future<Object?> _handleAction(BuildContext? context, ActionProp action,
      Emitter<DUIPageState> emit) async {
    switch (action.type) {
      // TODO: Move to some constant
      case 'Action.loadPage':
      case 'Action.rebuildPage':
        emit(state.copyWith(isLoading: true));
        final pagePropsJson = await PostAction(resolver).execute(action);

        if (pagePropsJson == null) {
          throw 'Props not found for Page: ${state.uid}';
        }

        final props = DUIPageProps.fromJson(pagePropsJson['response']);
        emit(state.copyWith(isLoading: false, props: props));
        return null;

      case 'Action.navigateToPage':
        final pageUId = action.data['pageId'];
        return openDUIPage(pageUid: pageUId, context: context!);

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

      default:
        emit(state.copyWith(isLoading: false));
        return null;
    }
    return null;
  }
}
