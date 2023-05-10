import 'dart:convert';

import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_card_props.g.dart';

@JsonSerializable()
class DUICardProps {
  late String color;
  late double height;
  late double width;
  late DUIInsets insets;
  late DUICornerRadius cornerRadius;
  late DUIImageProps thumbnail;
  late DUIImageProps authorProfile;
  late DUITextProps date;
  late DUITextProps authorName;
  late DUITextProps title;

  DUICardProps();

  factory DUICardProps.fromJson(Map<String, dynamic> json) =>
      _$DUICardPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICardPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  DUICardProps mockWidget() {
    return DUICardProps.fromJson(
      {
        "color": "#ACFBDC",
        "height": 170,
        "width": 360,
        "insets": {
          "top": 12,
          "bottom": 12,
          "left": 12,
          "right": 12,
        },
        "cornerRadius": {
          "bottomLeft": 12,
          "bottomRight": 12,
          "topLeft": 12,
          "topRight": 12,
        },
        "thumbnail": {
          "height": 1800,
          "imageSrc":
              "https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
          "fit": {
            "fit": "fitHeight",
          },
          "cornerRadius": {
            "bottomLeft": 12,
            "bottomRight": 0,
            "topLeft": 12,
            "topRight": 0,
          },
        },
        "date": {
          "style": "f:para3;tc:text",
          "textSpans": [
            {
              "text": "20/09/2000",
            },
          ]
        },
        "title": {
          "style": "f:para1;tc:textSubtle",
          "maxLines": 3,
          "overFlow": "jhgkjfhgv",
          "textSpans": [
            {
              "text":
                  "class FakeSubject extends Fake implements Subject {} const factory DUICardProps.eventName() = _eventName;",
            },
          ]
        },
        "authorProfile": {
          "height": 30,
          "width": 30,
          "imageSrc":
              "https://howtodrawforkids.com/wp-content/uploads/2021/06/How-to-draw-a-human-for-kids.jpg",
          "fit": {"fit": "contain"},
          "cornerRadius": {
            "bottomLeft": 1200,
            "bottomRight": 1200,
            "topLeft": 1200,
            "topRight": 1200,
          },
        },
        "authorName": {
          "style": "f:para3;tc:text",
          "textSpans": [
            {
              "text": "Premansh",
            },
          ]
        },
      },
    );
  }
}
