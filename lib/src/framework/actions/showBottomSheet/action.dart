import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/json_util.dart';
import '../../utils/object_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class ShowBottomSheetAction extends Action {
  final String viewId;
  final Map<String, ExprOr<Object>?>? args;
  final bool waitForResult;
  final JsonLike? style;
  final ActionFlow? onResult;

  ShowBottomSheetAction({
    required this.viewId,
    this.args,
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
      'viewId': viewId,
      'args': args,
      'waitForResult': waitForResult,
      'style': style,
      'onResult': onResult?.toJson(),
    };
  }

  factory ShowBottomSheetAction.fromJson(Map<String, Object?> json) {
    return ShowBottomSheetAction(
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
      waitForResult: json['waitForResult']?.to<bool>() ?? false,
      style: as$<JsonLike>(json['style']),
      onResult: ActionFlow.fromJson(json['onResult']),
    );
  }
}
