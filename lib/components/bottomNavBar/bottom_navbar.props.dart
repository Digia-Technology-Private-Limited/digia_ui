import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'bottom_navbar.props.g.dart';

@JsonSerializable()
class DUIBottomNavbarProps {
  late List<Map<String, dynamic>> items;
  late String type;
  DUIBottomNavbarProps();

  factory DUIBottomNavbarProps.fromJson(Map<String, dynamic> json) =>
      _$DUIBottomNavbarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIBottomNavbarPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  // DUIButtonProps mockWidget() {
  //   return DUIButtonProps.fromJson({
  //     "height": 100,
  //     "width": 400,
  //     "text": "Button",
  //     "textColor": "FFFFFF",
  //     "disabledTextColor": "808080",
  //     "backgroundColor": "00FF00",
  //     "disabledBackgroundColor": "C0C0C0",
  //     "disabled": true,
  //     "margin": {"top": 12, "left": 12, "right": 12, "bottom": 12},
  //     "padding": {"top": 12, "left": 12, "right": 12, "bottom": 12},
  //     "cornerRadius": {
  //       "topRight": 12,
  //       "topLeft": 12,
  //       "bottomLeft": 12,
  //       "bottomRight": 12,
  //     }
  //   });
  // }
}
