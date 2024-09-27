import '../../models/types.dart';
import '../base/action.dart';

class DelayAction extends Action {
  final ExprOr<int>? durationInMs;

  DelayAction({
    required this.durationInMs,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.delay;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'durationInMs': durationInMs?.toJson(),
      };

  factory DelayAction.fromJson(Map<String, Object?> json) {
    return DelayAction(
        durationInMs: ExprOr.fromJson<int>(json['durationInMs']));
  }
}
