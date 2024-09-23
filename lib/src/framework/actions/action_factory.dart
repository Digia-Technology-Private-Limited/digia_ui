import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';
import 'base/action.dart';
import 'controlDrawer/action.dart';
import 'copyToClipBoard/action.dart';
import 'delay/action.dart';
import 'navigateBack/action.dart';
import 'navigateBackUntil/action.dart';
import 'navigateToPage/action.dart';
import 'openUrl/action.dart';
import 'postMessage/action.dart';
import 'rebuild_page/action.dart';
import 'setState/action.dart';
import 'share/action.dart';
import 'showBottomSheet/action.dart';
import 'showDialog/action.dart';
import 'showToast/action.dart';

class ActionFactory {
  static Action fromJson(JsonLike json) {
    final actionType = ActionType.fromString(json['type'] as String)!;

    final disableActionIf = ExprOr.fromJson<bool>(json['disableActionIf']);

    final actionData = as$<JsonLike>(json['data']) ?? {};

    Action? action;

    switch (actionType) {
      case ActionType.callRestApi:
      // action = CallRestApiAction.fromJson(actionData);
      case ActionType.copyToClipBoard:
        action = CopyToClipBoardAction.fromJson(actionData);
      case ActionType.controlDrawer:
        action = ControlDrawerAction.fromJson(actionData);
      case ActionType.delay:
        action = DelayAction.fromJson(actionData);
      case ActionType.imagePicker:
      // action = ImagePickerAction.fromJson(actionData);
      case ActionType.navigateBack:
        action = NavigateBackAction.fromJson(actionData);
      case ActionType.navigateBackUntil:
        action = NavigateBackUntilAction.fromJson(actionData);
      case ActionType.navigateToPage:
        final openAs =
            tryKeys<String>(actionData, ['openAs', 'pageType']) ?? 'fullPage';
        if (openAs == 'bottomSheet') {
          action = ShowBottomSheetAction.fromJson(actionData);
        } else {
          action = NavigateToPageAction.fromJson(actionData);
        }
      case ActionType.openUrl:
        action = OpenUrlAction.fromJson(actionData);
      case ActionType.postMessage:
        action = PostMessageAction.fromJson(actionData);
      case ActionType.rebuildPage:
        action = RebuildPageAction.fromJson(actionData);
      case ActionType.setPageState:
        action = SetStateAction(
          stateContextName: 'page',
          updates: as$<List>(actionData['events'])
                  ?.map((e) => StateUpdate(
                        stateName: e['variableName'] as String,
                        newValue: ExprOr.fromJson<Object>(e['value']),
                      ))
                  .toList() ??
              [],
          rebuild: ExprOr.fromJson<bool>(actionData['rebuildPage']),
        );
      case ActionType.setState:
        action = SetStateAction.fromJson(actionData);
      case ActionType.shareContent:
        action = ShareAction.fromJson(actionData);
      case ActionType.showBottomSheet:
        action = ShowBottomSheetAction.fromJson(actionData);
      case ActionType.showDialog:
        action = ShowDialogAction.fromJson(actionData);
      case ActionType.showToast:
        action = ShowToastAction.fromJson(actionData);
      case ActionType.uploadFile:
      // action = UploadFileAction.fromJson(actionData);
    }

    // TODO: Remove force cast
    return action!..disableActionIf = disableActionIf;
  }
}
