
import '../../../digia_ui.dart';
import '../models/types.dart';
import '../utils/types.dart';

class SwitchProps {
  final ExprOr<bool>? enabled;
  final ExprOr<bool>? value;
  final ExprOr<String>? activeColor;

  final ExprOr<String>? inactiveThumbColor;

  final ExprOr<String>? activeTrackColor;

  final ExprOr<String>? inactiveTrackColor;
  final ActionFlow? onChanged;

  const SwitchProps({
    this.enabled,
    this.value,
    this.activeColor,
    this.inactiveThumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.onChanged,
  });

  factory SwitchProps.fromJson(JsonLike json) {
    return SwitchProps(
      enabled: ExprOr.fromJson<bool>(json['enabled']),
      value: ExprOr.fromJson<bool>(json['value']),
      activeColor: ExprOr.fromJson<String>(json['activeColor']),
      inactiveThumbColor: ExprOr.fromJson<String>(json['inactiveThumbColor']),
      activeTrackColor: ExprOr.fromJson<String>(json['activeTrackColor']),
      inactiveTrackColor: ExprOr.fromJson<String>(json['inactiveTrackColor']),
      onChanged: ActionFlow.fromJson(json['onChanged']),
    );
  }
}
