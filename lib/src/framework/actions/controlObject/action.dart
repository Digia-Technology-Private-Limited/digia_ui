import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class ControlObjectAction extends Action {
  final String stateContextName;
  final String objectName;
  final String method;
  final List<ExprOr<Object>?>? args;

  ControlObjectAction({
    required this.stateContextName,
    required this.objectName,
    required this.method,
    required this.args,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.controlObject;

  @override
  Map<String, dynamic> toJson() => {
        'stateContextName': stateContextName,
        'objectName': objectName,
        'method': method,
        'args': args?.map((e) => e?.toJson()).toList(),
      };

  factory ControlObjectAction.fromJson(Map<String, Object?> json) {
    return ControlObjectAction(
      stateContextName: as<String>(json['stateContextName']),
      objectName: as<String>(json['objectName']),
      method: as<String>(json['method']),
      args: as$<List>(json['args'])
          ?.map((e) => ExprOr.fromJson<Object>(e))
          .toList(),
    );
  }
}
