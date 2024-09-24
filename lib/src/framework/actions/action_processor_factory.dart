import 'package:digia_expr/digia_expr.dart';
import 'package:flutter/widgets.dart';

import '../utils/types.dart';
import 'base/action.dart' as an;
import 'base/action_flow.dart';
import 'base/processor.dart';
import 'controlDrawer/processor.dart';
import 'copyToClipBoard/processor.dart';
import 'delay/processor.dart';
import 'navigateBack/processor.dart';
import 'navigateBackUntil/processor.dart';
import 'navigateToPage/processor.dart';
import 'openUrl/processor.dart';
import 'postMessage/processor.dart';
import 'rebuild_page/processor.dart';
import 'setState/processor.dart';
import 'share/processor.dart';
import 'showBottomSheet/processor.dart';
import 'showDialog/processor.dart';
import 'showToast/processor.dart';

class ActionProcDependencies {
  final Widget Function(BuildContext context, String id, JsonLike? args)
      viewBuilder;
  final Route<Object> Function(BuildContext context, String id, JsonLike? args)
      pageRouteBuilder;
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ExprContext? exprContext,
  ) executeActionFlow;
  // Add other shared dependencies here

  ActionProcDependencies({
    required this.viewBuilder,
    required this.executeActionFlow,
    required this.pageRouteBuilder,
  });
}

class ActionProcessorFactory {
  final ActionProcDependencies dependencies;

  ActionProcessorFactory(this.dependencies);

  ActionProcessor getProcessor(an.Action action) {
    switch (action.actionType) {
      case an.ActionType.callRestApi:
      // return CallRestApiProcessor();
      case an.ActionType.controlDrawer:
        return ControlDrawerProcessor();
      case an.ActionType.copyToClipBoard:
        return CopyToClipBoardProcessor();
      case an.ActionType.delay:
        return DelayProcessor();
      // case an.ActionType.imagePicker:
      // return ImagePickerProcessor();
      case an.ActionType.navigateBack:
        return NavigateBackProcessor();
      case an.ActionType.navigateBackUntil:
        return NavigateBackUntilProcessor();
      case an.ActionType.navigateToPage:
        return NavigateToPageProcessor(
          executeActionFlow: dependencies.executeActionFlow,
          pageRouteBuilder: dependencies.pageRouteBuilder,
        );
      case an.ActionType.openUrl:
        return OpenUrlProcessor();
      case an.ActionType.postMessage:
        return PostMessageProcessor();
      case an.ActionType.rebuildPage:
        return RebuildPageProcessor();
      // case an.ActionType.setAppState:
      // return SetAppStateProcessor();
      case an.ActionType.setPageState:
      case an.ActionType.setState:
        return SetStateProcessor();
      case an.ActionType.shareContent:
        return ShareProcessor();
      case an.ActionType.showDialog:
        return ShowDialogProcessor(
          viewBuilder: dependencies.viewBuilder,
          executeActionFlow: dependencies.executeActionFlow,
        );
      case an.ActionType.showToast:
        return ShowToastProcessor();
      case an.ActionType.showBottomSheet:
        return ShowBottomSheetProcessor(
          executeActionFlow: dependencies.executeActionFlow,
          viewBuilder: dependencies.viewBuilder,
        );

      case an.ActionType.uploadFile:
      // return UploadFileProcessor();
      case an.ActionType.imagePicker:
      // TODO: Handle this case.
    }
    // TODO: Remove later
    return ShowToastProcessor();
  }
}
