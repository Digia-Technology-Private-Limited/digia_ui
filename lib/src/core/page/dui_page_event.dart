import 'package:flutter/material.dart';

abstract class DUIPageEvent {}

class InitPageEvent extends DUIPageEvent {
  final BuildContext context;

  InitPageEvent(this.context);
}

// class PostActionEvent extends DUIPageEvent {
//   final ActionProp action;
//   final BuildContext context;

//   PostActionEvent({required this.action, required this.context});
// }

class SingleSetStateEvent {
  final String variableName;
  final BuildContext context;
  final Object? value;

  SingleSetStateEvent(
      {required this.variableName, required this.context, required this.value});
}

class SetStateEvent extends DUIPageEvent {
  final List<SingleSetStateEvent> events;
  final bool rebuildPage;

  SetStateEvent({required this.events, required this.rebuildPage});
}
