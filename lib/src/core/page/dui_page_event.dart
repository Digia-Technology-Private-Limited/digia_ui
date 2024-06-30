import 'package:flutter/material.dart';

abstract class DUIPageEvent {}

class InitPageEvent extends DUIPageEvent {
  final BuildContext context;

  InitPageEvent(this.context);
}

class RebuildPageEvent extends DUIPageEvent {
  final BuildContext context;

  RebuildPageEvent(this.context);
}

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
