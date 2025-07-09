import '../../models/types.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class NavigateToPageAction extends Action {
  final ExprOr<JsonLike>? pageData;
  final bool waitForResult;
  final bool shouldRemovePreviousScreensInStack;
  final ExprOr<String>? routeNametoRemoveUntil;
  final ActionFlow? onResult;

  NavigateToPageAction({
    required this.pageData,
    this.waitForResult = false,
    this.shouldRemovePreviousScreensInStack = false,
    this.routeNametoRemoveUntil,
    this.onResult,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.navigateToPage;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'pageData': pageData?.toJson(),
        'waitForResult': waitForResult,
        'shouldRemovePreviousScreensInStack':
            shouldRemovePreviousScreensInStack,
        'routeNametoRemoveUntil': routeNametoRemoveUntil?.toJson(),
        'onResult': onResult?.toJson(),
      };

  factory NavigateToPageAction.fromJson(Map<String, Object?> json) {
    return NavigateToPageAction(
      pageData: ExprOr.fromJson<JsonLike>(json['pageData']),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      shouldRemovePreviousScreensInStack:
          json['shouldRemovePreviousScreensInStack']?.to<bool>() ?? false,
      routeNametoRemoveUntil:
          ExprOr.fromJson<String>(json['routeNametoRemoveUntil']),
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
