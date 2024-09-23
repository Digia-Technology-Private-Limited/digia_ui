import '../../models/types.dart';
import '../../utils/functional_util.dart';
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
        'type': actionType.toString(),
        'updates': updates,
        'rebuild': rebuild?.toJson(),
      };

  factory SetStateAction.fromJson(Map<String, Object?> json) {
    return SetStateAction(
      // fallback to 'page' if not set for backwar
      stateContextName: as<String>(json['stateContextName']),
      updates: (json['updates'] as List<dynamic>)
          .map((update) => StateUpdate.fromJson(update as Map<String, Object?>))
          .toList(),
      rebuild: ExprOr.fromJson<bool>(json['rebuild']),
    );
  }
}
