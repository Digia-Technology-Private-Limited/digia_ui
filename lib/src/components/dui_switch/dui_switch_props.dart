import 'package:json_annotation/json_annotation.dart';
part 'dui_switch_props.g.dart';

@JsonSerializable()
class DUISwitchProps {
  bool _value;
  bool get value => _value;
  bool _enabled;
  bool get enabled => _enabled;
  String? activeColor;
  String? inactiveThumbColor;
  String? activeTrackColor;
  String? inactiveTrackColor;

  DUISwitchProps({
    bool? value,
    bool? enabled,
    this.activeColor,
    this.inactiveThumbColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
  })  : _value = value ?? false,
        _enabled = enabled ?? true;

  factory DUISwitchProps.fromJson(dynamic json) => _$DUISwitchPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUISwitchPropsToJson(this);
}
