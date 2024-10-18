import '../actions/base/action_flow.dart';
import '../data_type/compex_object.dart';

import '../utils/types.dart';

class StreamBuilderProps {
  final EitherRefOrValue dataType;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  const StreamBuilderProps({
    required this.dataType,
    this.onSuccess,
    this.onError,
  });

  factory StreamBuilderProps.fromJson(JsonLike json) {
    return StreamBuilderProps(
      dataType: EitherRefOrValue.fromJson(json['dataType']),
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
    );
  }
}
