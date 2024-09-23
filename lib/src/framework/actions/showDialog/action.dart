import '../../models/types.dart';
import '../../utils/json_util.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowDialogAction extends Action {
  final String pageId;
  final JsonLike? pageArgs;
  final ExprOr<bool>? barrierDismissible;
  final ExprOr<String>? barrierColor;
  final bool waitForResult;
  final ActionFlow? onResult;

  ShowDialogAction({
    required this.pageId,
    required this.pageArgs,
    required this.barrierDismissible,
    required this.barrierColor,
    required this.waitForResult,
    required this.onResult,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.showDialog;

  @override
  Map<String, dynamic> toJson() => {
        'type': actionType.toString(),
        'pageUid': pageId,
        'pageArgs': pageArgs,
        'barrierDismissible': barrierDismissible?.toJson(),
        'barrierColor': barrierColor?.toJson(),
        'waitForResult': waitForResult,
        'onResult': onResult
      };

  factory ShowDialogAction.fromJson(Map<String, Object?> json) {
    return ShowDialogAction(
      pageId: tryKeys<String>(json, ['pageUid', 'pageId']) ?? '',
      pageArgs: tryKeys<JsonLike>(json, ['pageArgs', 'args']),
      barrierDismissible: ExprOr.fromJson<bool>(json['barrierDismissible']),
      barrierColor: ExprOr.fromJson<String>(json['barrierColor']),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
