import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';

class VariableUpdate {
  final String actionName;
  final ExprOr<Object>? value;

  VariableUpdate({
    required this.actionName,
    required this.value,
  });

  factory VariableUpdate.fromJson(Map<String, Object?> json) {
    return VariableUpdate(
      actionName: json['actionName'] as String,
      value: ExprOr.fromJson<Object>(json['value']),
    );
  }

  Map<String, dynamic> toJson() => {
    'actionName': actionName,
    'newValue': value,
  };
}

class ExecuteCallbackAction extends Action {
  final ExprOr actionName;
  final List<VariableUpdate> updates;


  ExecuteCallbackAction({
    required this.actionName,
    required this.updates,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.setState;

  @override
  Map<String, dynamic> toJson() => {
    'actionName': actionName,
    'updates': updates,
  };

  factory ExecuteCallbackAction.fromJson(Map<String, Object?> json) {
    return ExecuteCallbackAction(
      // fallback to 'page' if not set for backward compatibility.
      actionName: as<dynamic>(json['actionName']),
      updates: as$<List<dynamic>>(json['updates'])
          ?.map((it) => as$<JsonLike>(it))
          .nonNulls
          .map(VariableUpdate.fromJson)
          .toList() ??
          [],
    );
  }
}
