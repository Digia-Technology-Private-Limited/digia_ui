import 'package:collection/collection.dart';

import '../../models/types.dart';

enum ActionType {
  callRestApi('Action.callRestApi'),
  controlDrawer('Action.controlDrawer'),
  controlNavBar('Action.controlNavBar'),
  controlObject('Action.controlObject'),
  copyToClipBoard('Action.copyToClipBoard'),
  delay('Action.delay'),
  imagePicker('Action.imagePicker'),
  navigateBack('Action.pop'),
  navigateBackUntil('Action.popUntil'),
  navigateToPage('Action.navigateToPage'),
  openUrl('Action.openUrl'),
  postMessage('Action.handleDigiaMessage'),
  rebuildState('Action.rebuildState'),
  // setAppState('Action.setAppState'),
  setState('Action.setState'),
  executeCallback('Action.executeCallback'),
  shareContent('Action.share'),
  showBottomSheet('Action.showBottomSheet'),
  showDialog('Action.openDialog'),
  showToast('Action.showToast'),
  uploadFile('Action.upload'),
  filePicker('Action.filePicker'),
  fireEvent('Action.fireEvent'),
  setAppState('Action.setAppState');

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

  ActionId? get actionId;
  set actionId(ActionId? id);
}

abstract class Action with ActionMixin {
  @override
  ActionType get actionType;

  ActionId? _actionId;

  @override
  ActionId? get actionId => _actionId;

  @override
  set actionId(ActionId? id) => _actionId = id;

  ExprOr<bool>? disableActionIf;

  Action({
    this.disableActionIf,
  });

  Map<String, dynamic> toJson();
}

extension type ActionId(String id) {}
