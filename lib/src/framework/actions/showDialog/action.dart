import '../../models/types.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowDialogAction extends Action {
  // final String viewId;
  // final Map<String, ExprOr<Object>?>? args;
  final ExprOr<JsonLike>? viewData;
  final ExprOr<bool>? barrierDismissible;
  final ExprOr<String>? barrierColor;
  final bool waitForResult;
  final ActionFlow? onResult;

  ShowDialogAction({
    required this.viewData,
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
        'viewData': viewData?.toJson(),
        'barrierDismissible': barrierDismissible?.toJson(),
        'barrierColor': barrierColor?.toJson(),
        'waitForResult': waitForResult,
        'onResult': onResult
      };

  factory ShowDialogAction.fromJson(Map<String, Object?> json) {
    return ShowDialogAction(
      viewData: ExprOr.fromJson<JsonLike>(json['viewData']),
      barrierDismissible: ExprOr.fromJson<bool>(json['barrierDismissible']),
      barrierColor: ExprOr.fromJson<String>(json['barrierColor']),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
