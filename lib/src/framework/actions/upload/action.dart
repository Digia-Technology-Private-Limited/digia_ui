import 'dart:async';

import 'package:dio/dio.dart';

import '../../models/types.dart';
import '../../utils/types.dart';
import '../base/action.dart';
import '../base/action_flow.dart';

class UploadAction extends Action {
  final ExprOr<JsonLike>? dataSource;
  ExprOr<StreamController>? streamController;

  ExprOr<CancelToken>? cancelToken;
  final ExprOr<bool>? successCondition;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  UploadAction({
    required this.dataSource,
    this.streamController,
    this.cancelToken,
    this.successCondition,
    this.onSuccess,
    this.onError,
  });

  @override
  ActionType get actionType => ActionType.uploadFile;

  factory UploadAction.fromJson(Map<String, Object?> json) {
    return UploadAction(
      dataSource: ExprOr.fromJson<JsonLike>(json['dataSource']),
      successCondition: ExprOr.fromJson<bool>(json['successCondition']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
      streamController: ExprOr.fromJson(json['streamController']),
      cancelToken: ExprOr.fromJson(json['cancelToken']),
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
      'streamController': streamController?.toJson(),
      'cancelToken': cancelToken?.toJson()
    };
  }
}
