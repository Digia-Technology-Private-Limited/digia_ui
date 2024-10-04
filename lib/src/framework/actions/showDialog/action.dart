import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/json_util.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowDialogAction extends Action {
  final String viewId;
  final Map<String, ExprOr<Object>?>? args;
  final ExprOr<bool>? barrierDismissible;
  final ExprOr<String>? barrierColor;
  final bool waitForResult;
  final ActionFlow? onResult;

  ShowDialogAction({
    required this.viewId,
    required this.args,
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
        'viewId': viewId,
        'args': args,
        'barrierDismissible': barrierDismissible?.toJson(),
        'barrierColor': barrierColor?.toJson(),
        'waitForResult': waitForResult,
        'onResult': onResult
      };

  factory ShowDialogAction.fromJson(Map<String, Object?> json) {
    return ShowDialogAction(
      viewId: tryKeys<String>(json, [
            'pageUid',
            'pageId',
            'componentId',
            'viewId',
          ]) ??
          '',
      args: tryKeys<Map<String, ExprOr<Object>?>>(
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
