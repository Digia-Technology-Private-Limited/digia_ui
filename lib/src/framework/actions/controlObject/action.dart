import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class ControlObjectAction extends Action {
  final String stateContextName;
  final String objectName;
  final String method;
  final Map<String, ExprOr<Object>?>? args;

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
        'args': args?.map((k, v) => MapEntry(k, v?.toJson())),
      };

  factory ControlObjectAction.fromJson(Map<String, Object?> json) {
    final complexObject = json['controller'] as Map<String, Object?>?;
    return ControlObjectAction(
      stateContextName: as<String>(json['stateContextName']),
      objectName: as<String>(complexObject?['complexObject']),
      method: as<String>(complexObject?['method']),
      args: as$<Map<String, Object?>>(complexObject?['args'])?.map(
        (k, v) {
          final map = v as Map<String, Object>?;
          return MapEntry(k, ExprOr.fromJson<Object>(map?['data']));
        },
      ),
    );
  }
}
