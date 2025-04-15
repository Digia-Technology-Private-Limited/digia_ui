import '../../models/types.dart';
import '../base/action.dart';

class ControlDrawerAction extends Action {
  final ExprOr<String>? choice;

  ControlDrawerAction({required this.choice, super.disableActionIf});

  @override
  ActionType get actionType => ActionType.controlDrawer;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'choice': choice?.toJson(),
      };

  factory ControlDrawerAction.fromJson(Map<String, Object?> json) {
    return ControlDrawerAction(
      choice: ExprOr.fromJson<String>(json['choice']),
    );
  }
}
