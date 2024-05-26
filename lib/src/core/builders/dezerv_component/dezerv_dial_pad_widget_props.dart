import 'package:json_annotation/json_annotation.dart';

part 'dezerv_dial_pad_widget_props.g.dart';

@JsonSerializable()
class DezervDialPadProps {
  final double? defaultAmount;
  final double? maximumSipAmount;
  final num? minimumSipAmount;

  DezervDialPadProps(
      {this.defaultAmount, this.maximumSipAmount, this.minimumSipAmount});

  factory DezervDialPadProps.fromJson(Map<String, dynamic> json) {
    return _$DezervDialPadPropsFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DezervDialPadPropsToJson(this);
  }
}
