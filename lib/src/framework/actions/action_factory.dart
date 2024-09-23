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

    Action? action;

    switch (actionType) {
      case ActionType.callRestApi:
      // action = CallRestApiAction.fromJson(json);
      case ActionType.copyToClipBoard:
        action = CopyToClipBoardAction.fromJson(json);
      case ActionType.controlDrawer:
        action = ControlDrawerAction.fromJson(json);
      case ActionType.delay:
        action = DelayAction.fromJson(json);
      case ActionType.imagePicker:
      // action = ImagePickerAction.fromJson(json);
      case ActionType.navigateBack:
        action = NavigateBackAction.fromJson(json);
      case ActionType.navigateBackUntil:
        action = NavigateBackUntilAction.fromJson(json);
      case ActionType.navigateToPage:
        final openAs =
            tryKeys<String>(json, ['openAs', 'pageType']) ?? 'fullPage';
        if (openAs == 'bottomSheet') {
          action = ShowBottomSheetAction.fromJson(json);
        } else {
          action = NavigateToPageAction.fromJson(json);
        }
      case ActionType.openUrl:
        action = OpenUrlAction.fromJson(json);
      case ActionType.postMessage:
        action = PostMessageAction.fromJson(json);
      case ActionType.rebuildPage:
        action = RebuildPageAction.fromJson(json);
      case ActionType.setPageState:
        action = SetStateAction(
          stateContextName: 'page',
          updates: as$<List>(json['events'])
                  ?.map((e) => StateUpdate(
                        stateName: e['variableName'] as String,
                        newValue: ExprOr.fromJson<Object>(e['value']),
                      ))
                  .toList() ??
              [],
          rebuild: ExprOr.fromJson<bool>(json['rebuildPage']),
        );
      case ActionType.setState:
        action = SetStateAction.fromJson(json);
      case ActionType.shareContent:
        action = ShareAction.fromJson(json);
      case ActionType.showBottomSheet:
        action = ShowBottomSheetAction.fromJson(json);
      case ActionType.showDialog:
        action = ShowDialogAction.fromJson(json);
      case ActionType.showToast:
        action = ShowToastAction.fromJson(json);
      case ActionType.uploadFile:
      // action = UploadFileAction.fromJson(json);
    }

    // TODO: Remove force cast
    return action!..disableActionIf = disableActionIf;
  }
}
