import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/json_util.dart';
import '../utils/types.dart';

class StreamBuilderProps {
  final ExprOr<Object>? streamRef;
  final ActionFlow? onSuccess;
  final ActionFlow? onError;

  const StreamBuilderProps({
    this.streamRef,
    this.onSuccess,
    this.onError,
  });

  factory StreamBuilderProps.fromJson(JsonLike json) {
    var streamRef =
        ExprOr.fromJson<Object>(json.valueFor('streamVariable.name'));
    if (streamRef?.isExpr ?? false) {
      final streamName = as$<String>(json.valueFor('streamVariable.name'));
      streamRef = ExprOr.fromJson<Object>('\${params.$streamName}');
    }

    return StreamBuilderProps(
      streamRef: streamRef,
      onSuccess: ActionFlow.fromJson(json['onSuccess']),
      onError: ActionFlow.fromJson(json['onError']),
    );
  }
}
