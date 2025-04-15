import '../../models/types.dart';
import '../base/action.dart';

class CopyToClipBoardAction extends Action {
  final ExprOr<String>? message;

  CopyToClipBoardAction({required this.message, super.disableActionIf});

  @override
  ActionType get actionType => ActionType.copyToClipBoard;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'message': message?.toJson(),
      };

  factory CopyToClipBoardAction.fromJson(Map<String, Object?> json) {
    return CopyToClipBoardAction(
        message: ExprOr.fromJson<String>(json['message']));
  }
}
