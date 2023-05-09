import 'dart:convert';

import 'package:digia_ui/components/image/image.props.dart';
import 'package:json_annotation/json_annotation.dart';

import '../utils/DUICornerRadius/dui_corner_radius.dart';
import '../utils/DUIInsets/dui_insets.dart';

part 'tech_card.props.g.dart';

@JsonSerializable()
class DUITechCardProps {
  late double width;
  late double height;
  late DUIInsets margin;
  late DUIInsets padding;
  late DUICornerRadius cornerRadius;
  late DUIImageProps image;
  late String text1Color;
  late String text1;
  late String text2;
  late String text2Color;
  late String backgroundColor;
  double? font1Size;
  double? font2Size;
  DUITechCardProps();

  factory DUITechCardProps.fromJson(Map<String, dynamic> json) =>
      _$DUITechCardPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITechCardPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  DUITechCardProps mockWidget() {
    return DUITechCardProps.fromJson({
      "height": 130,
      "width": 180,
      "text1": "Kotlin",
      "text2": "Read more",
      "text1Color": "0000FF",
      "image": {
        "height": 50,
        "width": 50,
        "placeHolder": "",
        "errorFallback": "",
        "aspectRatio": 1,
        "margins": {"top": 5, "left": 5, "right": 5, "bottom": 5},
        "imageSrc":
            "https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
        "fit": {"fit": "fill"},
        "cornerRadius": {
          "topRight": 25,
          "topLeft": 25,
          "bottomLeft": 25,
          "bottomRight": 25,
        }
      },
      "text2Color": "FF0000",
      "backgroundColor": "00FFF0",
      "margin": {"top": 12, "left": 12, "right": 12, "bottom": 12},
      "padding": {"top": 12, "left": 12, "right": 12, "bottom": 12},
      "cornerRadius": {
        "topRight": 12,
        "topLeft": 12,
        "bottomLeft": 12,
        "bottomRight": 12,
      },
      "font1Size": 17,
      "font2Size": 17,
    });
  }
}
