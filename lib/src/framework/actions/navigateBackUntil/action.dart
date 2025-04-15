import '../../models/types.dart';
import '../base/action.dart';

class NavigateBackUntilAction extends Action {
  final ExprOr<String>? routeNameToPopUntil;

  NavigateBackUntilAction({
    required this.routeNameToPopUntil,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.navigateBackUntil;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'routeNameToPopUntil': routeNameToPopUntil?.toJson(),
      };

  factory NavigateBackUntilAction.fromJson(Map<String, Object?> json) {
    return NavigateBackUntilAction(
      routeNameToPopUntil: ExprOr.fromJson<String>(json['routeNameToPopUntil']),
    );
  }
}
