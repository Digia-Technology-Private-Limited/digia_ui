import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class CallRestApiAction extends Action {
  final String apiId;
  final Map<String, ExprOr<Object>?>? args;
  final ExprOr<bool>? successCondition;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  CallRestApiAction({
    required this.apiId,
    required this.args,
    this.successCondition,
    this.onSuccess,
    this.onError,
  });

  @override
  ActionType get actionType => ActionType.callRestApi;

  factory CallRestApiAction.fromJson(Map<String, Object?> json) {
    return CallRestApiAction(
      apiId: json['dataSourceId'] as String,
      args: as$<JsonLike>(json['args'])?.map((key, value) => MapEntry(
            key,
            ExprOr.fromJson<Object>(value),
          )),
      successCondition: ExprOr.fromJson<bool>(json['successCondition']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'dataSourceId': apiId,
      'args': args,
      'successCondition': successCondition?.toJson(),
      'onSuccess': onSuccess?.toJson(),
      'onError': onError?.toJson(),
    };
  }
}
