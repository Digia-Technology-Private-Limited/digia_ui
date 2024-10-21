import 'dart:async';

import '../../models/types.dart';
import '../../utils/functional_util.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class UploadAction extends Action {
  final String apiId;
  final Map<String, ExprOr<Object>?>? args;
  // final String? selectedPageStream;
  ExprOr<StreamController>? streamController;
  final ExprOr<bool>? successCondition;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  UploadAction({
    required this.apiId,
    required this.args,
    // this.selectedPageStream,
    this.streamController,
    this.successCondition,
    this.onSuccess,
    this.onError,
  });

  @override
  ActionType get actionType => ActionType.uploadFile;

  factory UploadAction.fromJson(Map<String, Object?> json) {
    return UploadAction(
      apiId: json['dataSourceId'] as String,
      args: as$<JsonLike>(json['args'])?.map((key, value) => MapEntry(
            key,
            ExprOr.fromJson<Object>(value),
          )),
      successCondition: ExprOr.fromJson<bool>(json['successCondition']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
      streamController: ExprOr.fromJson(json['streamController']),
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
      // 'selectedPageStream': selectedPageStream,
      'streamController': streamController?.toJson()
    };
  }
}
