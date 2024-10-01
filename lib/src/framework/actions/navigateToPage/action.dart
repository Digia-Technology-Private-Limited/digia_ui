import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/json_util.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class NavigateToPageAction extends Action {
  final String? pageId;
  final Map<String, ExprOr<Object>?>? pageArgs;
  final bool waitForResult;
  final bool shouldRemovePreviousScreensInStack;
  final ExprOr<String>? routeNametoRemoveUntil;
  final ActionFlow? onResult;

  NavigateToPageAction({
    required this.pageId,
    this.pageArgs,
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
        'pageUId': pageId,
        'pageArgs': pageArgs,
        'waitForResult': waitForResult,
        'shouldRemovePreviousScreensInStack':
            shouldRemovePreviousScreensInStack,
        'routeNametoRemoveUntil': routeNametoRemoveUntil?.toJson(),
        'onResult': onResult?.toJson(),
      };

  factory NavigateToPageAction.fromJson(Map<String, Object?> json) {
    return NavigateToPageAction(
      pageId: tryKeys<String>(json, ['pageUId', 'pageId']),
      pageArgs: tryKeys<Map<String, ExprOr<Object>?>>(
        json,
        ['pageArgs', 'args'],
        parse: (it) {
          return as$<JsonLike>(it)?.map((key, value) => MapEntry(
                key,
                ExprOr.fromJson<Object>(value),
              ));
        },
      ),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      shouldRemovePreviousScreensInStack:
          json['shouldRemovePreviousScreensInStack']?.to<bool>() ?? false,
      routeNametoRemoveUntil:
          ExprOr.fromJson<String>(json['routeNametoRemoveUntil']),
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
