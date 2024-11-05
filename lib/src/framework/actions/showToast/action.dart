import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';

class ShowToastAction extends Action {
  final ExprOr<String>? message;
  final ExprOr<int>? duration;
  final JsonLike? style;

  ShowToastAction({
    required this.message,
    required this.duration,
    required this.style,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.showToast;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'message': message?.toJson(),
        'duration': duration?.toJson(),
        'style': style,
      };

  factory ShowToastAction.fromJson(Map<String, Object?> json) {
    return ShowToastAction(
      message: ExprOr.fromJson<String>(json['message']),
      duration: ExprOr.fromJson<int>(json['duration']),
      style: as$<JsonLike>(json['style']),
    );
  }
}
