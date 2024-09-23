import '../base/action.dart';

class RebuildPageAction extends Action {
  RebuildPageAction({
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.rebuildPage;

  @override
  Map<String, dynamic> toJson() => {'type': actionType.toString()};

  factory RebuildPageAction.fromJson(Map<String, Object?> json) {
    return RebuildPageAction();
  }
}
