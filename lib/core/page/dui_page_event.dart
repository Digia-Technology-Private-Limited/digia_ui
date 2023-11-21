import 'package:digia_ui/core/action/action_prop.dart';
import 'package:flutter/material.dart';

abstract class DUIPageEvent {}

class InitPageEvent extends DUIPageEvent {
  final Map<String, dynamic>? pageParams;

  InitPageEvent({this.pageParams});
}

class PostActionEvent extends DUIPageEvent {
  final ActionProp action;
  final BuildContext context;

  PostActionEvent({required this.action, required this.context});
}
