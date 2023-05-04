import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'button.props.g.dart';

@JsonSerializable()
class DUIButtonProps {
  late double width;
  late double height;
  // late DUIInsets margins;
  // late DUIInsets paddings;
  // late DUICornerRadius cornerRadius;
  late String text;
  late String textColor;
  late String disabledTextColor;
  late String backgroundColor;
  late String disabledBackgroundColor;
  late bool disabled;
  DUIButtonProps();

  factory DUIButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIButtonPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
