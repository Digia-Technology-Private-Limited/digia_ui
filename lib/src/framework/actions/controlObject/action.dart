import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../base/action.dart';

class ControlObjectAction extends Action {
  final ExprOr<Object>? dataType;
  final String method;
  final Map<String, ExprOr<Object>?>? args;

  ControlObjectAction({
    required this.dataType,
    required this.method,
    required this.args,
    super.disableActionIf,
  });

  @override
  ActionType get actionType => ActionType.controlObject;

  @override
  Map<String, dynamic> toJson() => {
        'dataType': dataType?.toJson(),
        'method': method,
        'args': args?.map((k, v) => MapEntry(k, v?.toJson())),
      };

  factory ControlObjectAction.fromJson(Map<String, Object?> json) {
    return ControlObjectAction(
      dataType: ExprOr.fromJson<Object>(json['dataType']),
      method: as$<String>(json['method']) ?? 'unknown',
      args: as$<Map<String, Object?>>(json['args'])?.map(
        (k, v) => MapEntry(k, ExprOr.fromJson<Object>(v)),
      ),
    );
  }
}
