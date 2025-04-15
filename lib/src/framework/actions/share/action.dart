import '../../models/types.dart';
import '../base/action.dart';

class ShareAction extends Action {
  final ExprOr<String>? message;
  final ExprOr<String>? subject;

  ShareAction({
    required this.message,
    this.subject,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.shareContent;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'message': message?.toJson(),
        'subject': subject?.toJson(),
      };

  factory ShareAction.fromJson(Map<String, Object?> json) {
    return ShareAction(
      message: ExprOr.fromJson<String>(json['message']),
      subject: ExprOr.fromJson<String>(json['subject']),
    );
  }
}
