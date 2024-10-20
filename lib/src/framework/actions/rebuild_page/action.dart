import '../../utils/json_util.dart';
import '../base/action.dart';

class RebuildPageAction extends Action {
  final String? stateContextName;
  RebuildPageAction({
    super.disableActionIf,
    required this.stateContextName,
  });

  @override
  ActionType get actionType => ActionType.rebuildPage;

  @override
  Map<String, dynamic> toJson() =>
      {'type': actionType.toString(), 'stateContextName': stateContextName};

  factory RebuildPageAction.fromJson(Map<String, Object?> json) {
    return RebuildPageAction(
        stateContextName:
            tryKeys<String>(json, ['pageId', 'stateContextName']));
  }
}
