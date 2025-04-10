import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class ControlSetAppStateAction extends Action {
  final ExprOr<Object>? value;
  final String name;

  ControlSetAppStateAction({
    required this.name,
    this.value,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.setAppState;

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'value': value?.toJson(),
      };

  factory ControlSetAppStateAction.fromJson(Map<String, Object?> json) {
    return ControlSetAppStateAction(
      name: as<String>(json['name']),
      value: ExprOr.fromJson<Object>(json['value']),
    );
  }
}
