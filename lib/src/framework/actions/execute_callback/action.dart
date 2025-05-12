import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';

class ArgUpdate {
  final String argName;
  final ExprOr<Object>? argValue;

  ArgUpdate({
    required this.argName,
    required this.argValue,
  });

  factory ArgUpdate.fromJson(Map<String, Object?> json) {
    return ArgUpdate(
      argName: json['argName'] as String,
      argValue: ExprOr.fromJson<Object>(json['argValue']),
    );
  }

  Map<String, dynamic> toJson() => {
    'argName': argName,
    'argValue': argValue,
  };
}

class ExecuteCallbackAction extends Action {
  final ExprOr<Object>? actionName;
  final List<ArgUpdate> argUpdates;

  ExecuteCallbackAction({
    required this.actionName,
    required this.argUpdates,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.executeCallback;

  @override
  Map<String, dynamic> toJson() => {
    'actionName': actionName,
    'argUpdates': argUpdates,
  };

  factory ExecuteCallbackAction.fromJson(Map<String, Object?> json) {
    return ExecuteCallbackAction(
      // fallback to 'page' if not set for backward compatibility.
      actionName: ExprOr.fromJson(json['actionName']),
      argUpdates: as$<List<dynamic>>(json['argUpdates'])
          ?.map((it) => as$<JsonLike>(it))
          .nonNulls
          .map(ArgUpdate.fromJson)
          .toList() ??
          [],
    );
  }
}
