import 'package:digia_ui/Utils/config_resolver.dart';
import 'package:digia_ui/core/action/action_prop.dart';
import 'package:digia_ui/core/action/post_action.dart';
import 'package:digia_ui/core/page/dui_page_event.dart';
import 'package:digia_ui/core/page/dui_page_state.dart';
import 'package:digia_ui/core/page/props/dui_page_props.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DUIPageBloc extends Bloc<DUIPageEvent, DUIPageState> {
  final ConfigResolver resolver;

  DUIPageBloc({required DUIPageInitData initData, required this.resolver})
      : super(DUIPageState(
            uid: initData.identifier,
            isLoading: true,
            props: DUIPageProps.fromJson(initData.config))) {
    on<InitPageEvent>(_init);
    on<PostActionEvent>((event, emit) => _handleAction(event.action, emit));
  }

  void _init(
    InitPageEvent event,
    Emitter<DUIPageState> emit,
  ) async {
    // Assumption is that onPageLoadAction will not be null.
    // It will either be Action.loadPage or Action.buildPage
    final onPageLoadAction = state.props?.actions['onPageLoad'];

    final action = ActionProp.fromJson(onPageLoadAction);

    await _handleAction(action, emit);

    return;
  }

  Future<void> _handleAction(
      ActionProp action, Emitter<DUIPageState> emit) async {
    switch (action.type) {
      // TODO: Move to some constant
      case 'Action.loadPage':
        emit(state.copyWith(isLoading: true));
        final pagePropsJson = await PostAction(resolver).execute(action);

        if (pagePropsJson == null) {
          throw 'Props not found for Page: ${state.uid}';
        }

        final props = DUIPageProps.fromJson(pagePropsJson['response']);
        emit(state.copyWith(isLoading: false, props: props));

      default:
        emit(state.copyWith());
    }
  }
}
