import 'package:flutter/material.dart';

abstract class DUIComponentEvent {}

class InitComponentEvent extends DUIComponentEvent {
  final BuildContext context;

  InitComponentEvent(this.context);
}

class ComponentLoadedEvent extends DUIComponentEvent {
  final BuildContext context;

  ComponentLoadedEvent(this.context);
}

class BackPressEvent extends DUIComponentEvent {
  final BuildContext context;
  final bool didPop;

  BackPressEvent(this.context, this.didPop);
}

class RebuildComponentEvent extends DUIComponentEvent {
  final BuildContext context;

  RebuildComponentEvent(this.context);
}

class SingleSetStateEvent {
  final String variableName;
  final BuildContext context;
  final Object? value;

  SingleSetStateEvent(
      {required this.variableName, required this.context, required this.value});
}

class SetStateEvent extends DUIComponentEvent {
  final List<SingleSetStateEvent> events;
  final bool rebuildComponent;

  SetStateEvent({required this.events, required this.rebuildComponent});
}
