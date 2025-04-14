import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class SetAppStateAction extends Action {
  final ExprOr<Object>? value;
  final String name;

  SetAppStateAction({
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

  factory SetAppStateAction.fromJson(Map<String, Object?> json) {
    return SetAppStateAction(
      name: as<String>(json['name']),
      value: ExprOr.fromJson<Object>(json['value']),
    );
  }
}
