import '../actions/base/action_flow.dart';

import '../internal_widgets/async_builder/controller.dart';
import '../models/types.dart';
import '../utils/types.dart';

class AsyncBuilderProps {
  final ExprOr<JsonLike>? future;
  final ExprOr<AsyncController>? controller;
  final ExprOr<Object>? initialData;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  const AsyncBuilderProps({
    this.future,
    this.controller,
    this.initialData,
    this.onSuccess,
    this.onError,
  });

  factory AsyncBuilderProps.fromJson(JsonLike json) {
    return AsyncBuilderProps(
      future: ExprOr.fromJson<JsonLike>(json['future']),
      controller: ExprOr.fromJson<AsyncController>(json['controller']),
      initialData: ExprOr.fromJson<Object>(json['initialData']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
    );
  }
}
