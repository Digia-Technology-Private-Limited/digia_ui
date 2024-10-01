import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/json_util.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowDialogAction extends Action {
  final String pageId;
  final Map<String, ExprOr<Object>?>? pageArgs;
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
      barrierDismissible: ExprOr.fromJson<bool>(json['barrierDismissible']),
      barrierColor: ExprOr.fromJson<String>(json['barrierColor']),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
