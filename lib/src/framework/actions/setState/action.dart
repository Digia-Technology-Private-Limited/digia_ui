import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';

class StateUpdate {
  final String stateName;
  final ExprOr<Object>? newValue;

  StateUpdate({
    required this.stateName,
    required this.newValue,
  });

  factory StateUpdate.fromJson(Map<String, Object?> json) {
    return StateUpdate(
      stateName: json['stateName'] as String,
      newValue: ExprOr.fromJson<Object>(json['newValue']),
    );
  }

  Map<String, dynamic> toJson() => {
        'stateName': stateName,
        'newValue': newValue,
      };
}

class SetStateAction extends Action {
  // A null value means the origin state context
  final String stateContextName;
  final List<StateUpdate> updates;
  final ExprOr<bool>? rebuild;

  SetStateAction({
    required this.stateContextName,
    required this.updates,
    required this.rebuild,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.setPageState;

  @override
  Map<String, dynamic> toJson() => {
        'stateContextName': actionType.toString(),
        'updates': updates,
        'rebuild': rebuild?.toJson(),
      };

  factory SetStateAction.fromJson(Map<String, Object?> json) {
    return SetStateAction(
      // fallback to 'page' if not set for backward compatibility.
      stateContextName: as<String>(json['stateContextName']),
      updates: as$<List>(json['updates'])
              ?.map((it) => as$<JsonLike>(it))
              .nonNulls
              .map(StateUpdate.fromJson)
              .toList() ??
          [],
      rebuild: ExprOr.fromJson<bool>(json['rebuild']),
    );
  }
}
