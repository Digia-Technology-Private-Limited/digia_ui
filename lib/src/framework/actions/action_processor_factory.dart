import 'package:digia_inspector_core/digia_inspector_core.dart';
import 'package:flutter/widgets.dart';

import '../data_type/method_bindings/method_binding_registry.dart';
import '../expr/scope_context.dart';
import '../utils/types.dart';
import 'action_execution_context.dart';
import 'base/action.dart' as an;
import 'base/action_flow.dart';
import 'base/processor.dart';
import 'callRestApi/processor.dart';
import 'controlDrawer/processor.dart';
import 'controlNavBar/processor.dart';
import 'controlObject/processor.dart';
import 'copyToClipBoard/processor.dart';
import 'delay/processor.dart';
import 'event/processor.dart';
import 'execute_callback/processor.dart';
import 'filePicker/processor.dart';
import 'imagePicker/processor.dart';
import 'navigateBack/processor.dart';
import 'navigateBackUntil/processor.dart';
import 'navigateToPage/processor.dart';
import 'openUrl/processor.dart';
import 'postMessage/processor.dart';
import 'rebuild_state/processor.dart';
import 'setState/processor.dart';
import 'set_app_state/processor.dart';
import 'share/processor.dart';
import 'showBottomSheet/processor.dart';
import 'showDialog/processor.dart';
import 'showToast/processor.dart';
import 'upload/processor.dart';

class ActionProcDependencies {
  final Widget Function(BuildContext context, String id, JsonLike? args)
      viewBuilder;
  final Route<Object> Function(
    BuildContext context,
    String id,
    JsonLike? args,
  ) pageRouteBuilder;
  final Future<Object?>? Function(
    BuildContext context,
    ActionFlow actionFlow,
    ScopeContext? scopeContext, {
    required String id,
    String? parentActionId,
    ObservabilityContext? observabilityContext,
  }) executeActionFlow;
  final MethodBindingRegistry bindingRegistry;
  // Add other shared dependencies here

  ActionProcDependencies({
    required this.viewBuilder,
    required this.executeActionFlow,
    required this.pageRouteBuilder,
    required this.bindingRegistry,
  });
}

class ActionProcessorFactory {
  final ActionProcDependencies dependencies;
  final ActionExecutionContext executionContext;

  ActionProcessorFactory(this.dependencies, this.executionContext);

  ActionProcessor? actionProcessor;
  ActionProcessor getProcessor(an.Action action) {
    switch (action.actionType) {
      case an.ActionType.callRestApi:
        actionProcessor = CallRestApiProcessor(
          executeActionFlow: dependencies.executeActionFlow,
        );
      case an.ActionType.controlDrawer:
        actionProcessor = ControlDrawerProcessor();
      case an.ActionType.controlNavBar:
        actionProcessor = ControlNavBarProcessor();
      case an.ActionType.controlObject:
        actionProcessor = ControlObjectProcessor(
          registry: dependencies.bindingRegistry,
        );
      case an.ActionType.copyToClipBoard:
        actionProcessor = CopyToClipBoardProcessor();
      case an.ActionType.delay:
        actionProcessor = DelayProcessor();
      case an.ActionType.imagePicker:
        actionProcessor = ImagePickerProcessor();
      case an.ActionType.navigateBack:
        actionProcessor = NavigateBackProcessor();
      case an.ActionType.navigateBackUntil:
        actionProcessor = NavigateBackUntilProcessor();
      case an.ActionType.navigateToPage:
        actionProcessor = NavigateToPageProcessor(
          executeActionFlow: dependencies.executeActionFlow,
          pageRouteBuilder: dependencies.pageRouteBuilder,
        );
      case an.ActionType.openUrl:
        actionProcessor = OpenUrlProcessor();
      case an.ActionType.postMessage:
        actionProcessor = PostMessageProcessor();
      case an.ActionType.rebuildState:
        actionProcessor = RebuildStateProcessor();
      case an.ActionType.setState:
        actionProcessor = SetStateProcessor();
      case an.ActionType.shareContent:
        actionProcessor = ShareProcessor();
      case an.ActionType.showDialog:
        actionProcessor = ShowDialogProcessor(
          viewBuilder: dependencies.viewBuilder,
          executeActionFlow: dependencies.executeActionFlow,
        );
      case an.ActionType.showToast:
        actionProcessor = ShowToastProcessor();
      case an.ActionType.showBottomSheet:
        actionProcessor = ShowBottomSheetProcessor(
          executeActionFlow: dependencies.executeActionFlow,
          viewBuilder: dependencies.viewBuilder,
        );
      case an.ActionType.filePicker:
        actionProcessor = FilePickerProcessor();
      case an.ActionType.uploadFile:
        actionProcessor = UploadProcessor(
          executeActionFlow: dependencies.executeActionFlow,
        );
      case an.ActionType.fireEvent:
        actionProcessor = FireEventProcessor(
            executeActionFlow: dependencies.executeActionFlow);
      case an.ActionType.setAppState:
        actionProcessor = SetAppStateProcessor();
      case an.ActionType.executeCallback:
        actionProcessor = ExecuteCallbackProcessor(
          executeActionFlow: dependencies.executeActionFlow,
        );
    }
    actionProcessor?.executionContext = executionContext;
    return (actionProcessor ?? ShowToastProcessor());
  }
}
