import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowBottomSheetAction extends Action {
  final ExprOr<JsonLike>? viewData;
  final bool waitForResult;
  final JsonLike? style;
  final ActionFlow? onResult;

  ShowBottomSheetAction({
    required this.viewData,
    this.waitForResult = false,
    this.onResult,
    this.style,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.showBottomSheet;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'viewData': viewData?.toJson(),
      'waitForResult': waitForResult,
      'style': style,
      'onResult': onResult?.toJson(),
    };
  }

  factory ShowBottomSheetAction.fromJson(Map<String, Object?> json) {
    return ShowBottomSheetAction(
      viewData: ExprOr.fromJson<JsonLike>(json['viewData']),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      style: as$<JsonLike>(json['style']),
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
