import 'package:digia_ui/src/Utils/config_resolver.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:digia_ui/src/core/action/post_action.dart';
import 'package:digia_ui/src/core/page/dui_page.dart';
import 'package:digia_ui/src/core/page/dui_page_event.dart';
import 'package:digia_ui/src/core/page/dui_page_state.dart';
import 'package:digia_ui/src/core/page/props/dui_page_props.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/basic_shared_utils/dui_decoder.dart';

class DUIPageBloc extends Bloc<DUIPageEvent, DUIPageState> {
  final ConfigResolver resolver;

  DUIPageBloc({required DUIPageInitData initData, required this.resolver})
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
        final pageId = action.data['pageId'];
        final pageConfig = ConfigResolver().getPageConfig(pageId);

        // TODO: Fix this lint error.
        return Navigator.push(context!, MaterialPageRoute(builder: (ctx) {
          return BlocProvider(
            create: (context) {
              return DUIPageBloc(
                  initData:
                      DUIPageInitData(identifier: pageId, config: pageConfig!),
                  resolver: ConfigResolver())
                ..add(InitPageEvent(pageParams: action.data['args']));
            },
            child: const DUIPage(),
          );
        }));

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
