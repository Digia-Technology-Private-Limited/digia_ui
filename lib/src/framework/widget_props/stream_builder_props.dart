import 'dart:async';

import '../actions/base/action_flow.dart';

import '../models/types.dart';
import '../utils/types.dart';

class StreamBuilderProps {
  final ExprOr<StreamController>? controller;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  const StreamBuilderProps({
    this.controller,
    this.onSuccess,
    this.onError,
  });

  factory StreamBuilderProps.fromJson(JsonLike json) {
    return StreamBuilderProps(
      controller: ExprOr.fromJson<StreamController>(json['controller']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
    );
  }
}
