import '../../models/types.dart';
import '../base/action.dart';

class ControlNavBarAction extends Action {
  final ExprOr<num>? index;

  ControlNavBarAction({required this.index, super.disableActionIf});

  @override
  ActionType get actionType => ActionType.controlNavBar;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'index': index?.toJson(),
      };

  factory ControlNavBarAction.fromJson(Map<String, Object?> json) {
    return ControlNavBarAction(
      index: ExprOr.fromJson<num>(json['index']),
    );
  }
}
