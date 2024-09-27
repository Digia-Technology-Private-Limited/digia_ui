import '../../models/types.dart';
import '../base/action.dart';

class NavigateBackAction extends Action {
  final ExprOr<bool>? maybe;
  final ExprOr<Object>? result;

  NavigateBackAction({
    required this.maybe,
    required this.result,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.navigateBack;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'maybe': maybe?.toJson(),
        'result': result?.toJson(),
      };

  factory NavigateBackAction.fromJson(Map<String, Object?> json) {
    return NavigateBackAction(
      maybe: ExprOr.fromJson<bool>(json['maybe']) ?? ExprOr(false),
      result: ExprOr.fromJson(json['result']),
    );
  }
}
