import '../actions/base/action_flow.dart';
import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class PinFieldProps {
  final ExprOr<int>? length;
  final ExprOr<bool>? autoFocus;
  final ExprOr<bool>? enabled;
  final ExprOr<bool>? obscureText;
  final JsonLike? defaultPinTheme;
  final ActionFlow? onChanged;
  final ActionFlow? onCompleted;

  PinFieldProps({
    required this.length,
    required this.autoFocus,
    required this.enabled,
    required this.obscureText,
    required this.defaultPinTheme,
    required this.onChanged,
    required this.onCompleted,
  });

  factory PinFieldProps.fromJson(Map<String, dynamic> json) {
    return PinFieldProps(
      length: ExprOr.fromJson<int>(json['length']),
      autoFocus: ExprOr.fromJson<bool>(json['autoFocus']),
      enabled: ExprOr.fromJson<bool>(json['enabled']),
      obscureText: ExprOr.fromJson<bool>(json['obscureText']),
      defaultPinTheme: as$<JsonLike>(json['defaultPinTheme']),
      onChanged: ActionFlow.fromJson(json['onChanged']),
      onCompleted: ActionFlow.fromJson(json['onCompleted']),
    );
  }
}
