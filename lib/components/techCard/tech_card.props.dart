import 'dart:convert';

import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';


part 'tech_card.props.g.dart';

@JsonSerializable()
class DUITechCardProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  DUIStyleClass? styleClass;
  late double? width;
  late double? height;
  late String spaceBtwImageAndTitle;
  late DUIImageProps image;
  late DUITextProps title;
  late DUITextProps subText;
  DUITechCardProps();

  factory DUITechCardProps.fromJson(Map<String, dynamic> json) =>
      _$DUITechCardPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITechCardPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  static DUITechCardProps mockWidget() {
    return DUITechCardProps.fromJson({
      "height": 160,
      "width": 200,
      "image": {
        "height": 48,
        "width": 48,
        "aspectRatio": 1,
        "imageSrc":
            "https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
        "fit": "fill",
        "cornerRadius": {
          "topRight": 25,
          "topLeft": 25,
          "bottomLeft": 25,
          "bottomRight": 25,
        }
      },
      "bgColor": "accent1",
      "title": {
        "styleClass": "ft:h2-medium;tc:text",
        "textSpans": [
          {
            "text": "Kotlin",
          },
        ]
      },
      "subText": {
        "styleClass": "ft:para3;tc:textSubtle",
        "textSpans": [
          {
            "text": "Programming",
          },
        ]
      }
    });
  }
}
