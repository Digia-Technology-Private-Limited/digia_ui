import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:flutter/material.dart';

abstract class DUIPageEvent {}

class InitPageEvent extends DUIPageEvent {
  final Map<String, dynamic>? pageParams;

  InitPageEvent({this.pageParams});
}

// class PostActionEvent extends DUIPageEvent {
//   final ActionProp action;
//   final BuildContext context;

//   PostActionEvent({required this.action, required this.context});
// }

class SetStateEvent extends DUIPageEvent {
  final String variableName;
  final BuildContext context;
  // TODO: This will be some form of an Expression.
  final Object? value;

  SetStateEvent(
      {required this.variableName, required this.context, required this.value});
}
