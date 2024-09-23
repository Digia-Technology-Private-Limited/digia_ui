import '../../utils/functional_util.dart';
import '../../utils/json_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowBottomSheetAction extends Action {
  final String? pageId;
  final JsonLike? pageArgs;
  final bool waitForResult;
  final JsonLike? style;
  final ActionFlow? onResult;

  ShowBottomSheetAction({
    required this.pageId,
    this.pageArgs,
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
      'pageId': pageId,
      'pageArgs': pageArgs,
      'waitForResult': waitForResult,
      'style': style,
      'onResult': onResult?.toJson(),
    };
  }

  factory ShowBottomSheetAction.fromJson(Map<String, dynamic> json) {
    return ShowBottomSheetAction(
      pageId: tryKeys<String>(json, ['pageUId', 'pageId']),
      pageArgs: tryKeys<JsonLike>(json, ['pageArgs', 'args']),
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      style: as$<JsonLike>(json['style']),
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
