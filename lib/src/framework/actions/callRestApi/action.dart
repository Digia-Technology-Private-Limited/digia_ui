import '../../models/types.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class CallRestApiAction extends Action {
  final ExprOr<JsonLike>? dataSource;
  final ExprOr<bool>? successCondition;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  CallRestApiAction({
    required this.dataSource,
    this.successCondition,
    this.onSuccess,
    this.onError,
  });

  @override
  ActionType get actionType => ActionType.callRestApi;

  factory CallRestApiAction.fromJson(Map<String, Object?> json) {
    return CallRestApiAction(
      dataSource: ExprOr.fromJson<JsonLike>(json['dataSource']),
      successCondition: ExprOr.fromJson<bool>(json['successCondition']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': actionType.toString(),
      'dataSource': dataSource?.toJson(),
      'successCondition': successCondition?.toJson(),
      'onSuccess': onSuccess?.toJson(),
      'onError': onError?.toJson(),
    };
  }
}
