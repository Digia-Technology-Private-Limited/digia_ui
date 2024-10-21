import '../../utils/json_util.dart';
import '../base/action.dart';

class RebuildStateAction extends Action {
  final String? stateContextName;
  RebuildStateAction({
    super.disableActionIf,
    required this.stateContextName,
  });

  @override
  ActionType get actionType => ActionType.rebuildState;

  @override
  Map<String, dynamic> toJson() =>
      {'type': actionType.toString(), 'stateContextName': stateContextName};

  factory RebuildStateAction.fromJson(Map<String, Object?> json) {
    return RebuildStateAction(
        stateContextName: tryKeys<String>(json, ['stateContextName']));
  }
}
