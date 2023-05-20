import 'dart:convert';

import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/button/button.props.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'onboarding_props.g.dart';

@JsonSerializable()
class OnBoardingProps {
  late double height;
  late double width;
  late String color;
  late DUIInsets? insets;
  late DUICornerRadius? cornerRadius;
  late DUITextProps logoText;
  late DUITextProps title;
  late DUITextProps subTitle;
  late DUIButtonProps? button;

  OnBoardingProps();

  factory OnBoardingProps.fromJson(Map<String, dynamic> json) =>
      _$OnBoardingPropsFromJson(json);

  Map<String, dynamic> toJson() => _$OnBoardingPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  OnBoardingProps mockWidget() {
    return OnBoardingProps.fromJson({
      "color": "primary",
      "height": 350,
      "width": 360,
      "logoText": {
        "style": "f:heading1Loose;tc:light;ff:appleli",
        "textSpans": [
          {
            "text": "BYTES",
          }
        ],
      },
      "title": {
        "style": "f:heading1Tight;tc:text;ff:poppins",
        "textSpans": [
          {
            "text": "Stoppage for\nyour ",
          },
          {
            "style": "tc:secondary;",
            "text": "Curiosity",
          }
        ],
      },
      "subTitle": {
        "style": "f:para3;tc:textSubtle;ff:poppins",
        "textSpans": [
          {
            "text":
                "Discover Bytes, an intuitive and versatile\nContent Platform powered by Lokal.",
          },
        ],
      },
    });
  }
}
