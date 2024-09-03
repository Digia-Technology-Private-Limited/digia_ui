import 'dart:async';

import 'package:digia_expr/digia_expr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utils/expr.dart';
import '../../config_resolver.dart';
import '../action/action_handler.dart';
import 'dui_component_event.dart';
import 'dui_component_state.dart';

class DUIComponentBloc extends Bloc<DUIComponentEvent, DUIComponentState> {
  final DUIConfig config;

  DUIComponentBloc({
    required String componentUid,
    required this.config,
    Map<String, dynamic>? componentArgs,
  }) : super(DUIComponentState(
            componentUid: componentUid,
            isLoading: true,
            componentArgs: componentArgs,
            props: config.getComponentData(componentUid),
            widgetVars: {})) {
    on<InitComponentEvent>(_init);
    on<SetStateEvent>(_setState);
    on<RebuildComponentEvent>(_rebuildComponent);
    on<ComponentLoadedEvent>(_pageLoaded);
    on<BackPressEvent>(_backPressed);
  }

  void register(String widgetName, Map<String, Function> getters) {
    state.widgetVars[widgetName] = getters;
  }

  void _init(
    InitComponentEvent blocEvent,
    Emitter<DUIComponentState> emit,
  ) async {
    final componentStates = state.props.variables;
    if (componentStates != null) {
      for (final element in componentStates.entries) {
        final componentStateDefaultValue = element.value.value;
        final evaluatedValue = evalDynamic(componentStateDefaultValue,
            blocEvent.context, ExprContext(variables: {}));
        state.props.variables?[element.key]?.set(evaluatedValue);
      }
    }
    emit(state.copyWith(isLoading: false));
    return;
  }

  void _rebuildComponent(
      RebuildComponentEvent event, Emitter<DUIComponentState> emit) {
    emit(state.copyWith());
  }

  void _setState(
    SetStateEvent event,
    Emitter<DUIComponentState> emit,
  ) {
    for (final element in event.events) {
      state.props.variables?[element.variableName]?.set(element.value);
    }

    if (event.rebuildComponent) {
      emit(state.copyWith());
    }
  }

  FutureOr<void> _pageLoaded(
      ComponentLoadedEvent event, Emitter<DUIComponentState> emit) {
    final componentLoadedActionFlow = state.props.onComponentLoad;
    if (componentLoadedActionFlow != null) {
      ActionHandler.instance.execute(
          context: event.context, actionFlow: componentLoadedActionFlow);
    }
  }

  FutureOr<void> _backPressed(
      BackPressEvent event, Emitter<DUIComponentState> emit) {
    final actionFlow = state.props.onBackPress;
    if (actionFlow != null) {
      ActionHandler.instance
          .execute(context: event.context, actionFlow: actionFlow);
    }
  }
}
