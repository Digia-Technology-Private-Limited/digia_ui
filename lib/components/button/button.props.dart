import 'dart:convert';

import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/DUIInsets/dui_insets.dart';

part 'button.props.g.dart';

@JsonSerializable()
class DUIButtonProps {
  double? width;
  double? height;
  DUIInsets? margin;
  DUIInsets? padding;
  String? shape;
  late DUITextProps text;
  String? textColor;
  String? disabledTextColor;
  String? backgroundColor;
  String? disabledBackgroundColor;
  bool? disabled;
  double? fontSize;
  DUIButtonProps();

  factory DUIButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIButtonPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  DUIButtonProps mockWidget() {
    return DUIButtonProps.fromJson(
      {
        "backgroundColor": "#345678",
        "width": 200,
        "shape": "pill",
        "text": {
          "style": "f:heading1Loose;tc:accent5",
          "maxLines": 2,
          "textSpans": [
            {
              "text": "Button",
              "textAlign": "center",
            },
          ],
        },
      },
    );
  }
}
