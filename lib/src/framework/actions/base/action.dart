import 'package:collection/collection.dart';

import '../../models/types.dart';

enum ActionType {
  callRestApi('Action.callRestApi'),
  controlDrawer('Action.controlDrawer'),
  controlObject('Action.controlObject'),
  copyToClipBoard('Action.copyToClipBoard'),
  delay('Action.delay'),
  imagePicker('Action.imagePicker'),
  navigateBack('Action.pop'),
  navigateBackUntil('Action.popUntil'),
  navigateToPage('Action.navigateToPage'),
  openUrl('Action.openUrl'),
  postMessage('Action.handleDigiaMessage'),
  rebuildPage('Action.rebuildPage'),
  // setAppState('Action.setAppState'),
  // For Backward Compatibility, to be removed in future
  setPageState('Action.setPageState'),
  setState('Action.setState'),
  shareContent('Action.share'),
  showBottomSheet('Action.showBottomSheet'),
  showDialog('Action.openDialog'),
  showToast('Action.showToast'),
  uploadFile('Action.upload'),
  filePicker('Action.filePicker');

  final String value;
  const ActionType(this.value);

  static ActionType? fromString(String value) {
    return ActionType.values.firstWhereOrNull(
      (type) => type.value == value,
    );
  }
}

mixin ActionMixin {
  ActionType get actionType;
}

abstract class Action with ActionMixin {
  @override
  ActionType get actionType;
  ExprOr<bool>? disableActionIf;
  Action({
    this.disableActionIf,
  });

  Map<String, dynamic> toJson();
}
