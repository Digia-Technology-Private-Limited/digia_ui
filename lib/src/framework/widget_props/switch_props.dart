import 'dart:ui';

import '../models/types.dart';
import '../utils/types.dart';

class SwitchProps {
  final ExprOr<bool>? enabled;
  final ExprOr<bool>? value;
  final ExprOr<Color>? activeColor;

  final ExprOr<Color>? inactiveThumbColor;

  final ExprOr<Color>? activeTrackColor;

  final ExprOr<Color>? inactiveTrackColor;

  const SwitchProps({
    this.enabled,
    this.value,
    this.activeColor,
    this.inactiveThumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
  });

  factory SwitchProps.fromJson(JsonLike json) {
    return SwitchProps(
      enabled: ExprOr.fromJson<bool>(json['enabled']),
      value: ExprOr.fromJson<bool>(json['value']),
      activeColor: ExprOr.fromJson<Color>(json['activeColor']),
      inactiveThumbColor: ExprOr.fromJson<Color>(json['inactiveThumbColor']),
      activeTrackColor: ExprOr.fromJson<Color>(json['activeTrackColor']),
      inactiveTrackColor: ExprOr.fromJson<Color>(json['inactiveTrackColor']),
    );
  }
}
