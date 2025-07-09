import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../setState/action.dart';

class SetAppStateAction extends Action {
  final List<StateUpdate> updates;

  SetAppStateAction({
    required this.updates,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.setAppState;

  @override
  Map<String, dynamic> toJson() => {
        'updates': updates.map((e) => e.toJson()).toList(),
      };

  factory SetAppStateAction.fromJson(Map<String, Object?> json) {
    return SetAppStateAction(
      updates: as$<List<dynamic>>(json['updates'])
              ?.map((it) => as$<JsonLike>(it))
              .nonNulls
              .map(StateUpdate.fromJson)
              .toList() ??
          [],
    );
  }
}
