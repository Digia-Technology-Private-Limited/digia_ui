import 'package:digia_ui/core/action/action_prop.dart';

abstract class DUIPageEvent {}

class InitPageEvent extends DUIPageEvent {}

class PostActionEvent extends DUIPageEvent {
  final ActionProp action;

  PostActionEvent({required this.action});
}
