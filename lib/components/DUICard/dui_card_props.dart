import 'dart:convert';

import 'package:digia_ui/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/components/image/image.props.dart';
import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_card_props.g.dart';

@JsonSerializable()
class DUICardProps {
  late String bgColor;
  late double height;
  late double width;
  late DUIInsets contentMargin;
  late DUICornerRadius cornerRadius;
  late DUIImageProps image;
  DUIInsets imageMargin = DUIInsets();
  late DUITextProps title;
  late DUITextProps topCrumbText;
  late String spaceBtwTopCrumbTextTitle;
  late DUITextProps avatarText;
  late DUIImageProps avatarImage;
  late String spaceBtwAvatarImageAndText;

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
        "bgColor": "accent1",
        "height": 150,
        "width": 360,
        "contentMargin": {
          "top": "sp-250",
          "bottom": "sp-250",
          "left": "sp-250",
          "right": "sp-250",
        },
        "cornerRadius": {
          "bottomLeft": 8,
          "bottomRight": 8,
          "topLeft": 8,
          "topRight": 8,
        },
        "image": {
          "height": 1800,
          "imageSrc":
              "https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
          "fit": {
            "fit": "fitHeight",
          },
          "cornerRadius": {
            "bottomLeft": 12,
            "topLeft": 12,
          },
        },
        "imageMargin": {
          "top": "0",
          "bottom": "0",
          "left": "0",
          "right": "0",
        },
        "topCrumbText": {
          "styleClass": "ft:caption;tc:textSubtle",
          "textSpans": [
            {
              "text": "April 11, 2023",
            },
          ]
        },
        "spaceBtwTopCrumbTextTitle": "sp-100",
        "title": {
          "styleClass": "ft:para2;tc:text",
          "maxLines": 3,
          "overFlow": "jhgkjfhgv",
          "textSpans": [
            {
              "text":
                  "class FakeSubject extends Fake implements Subject {} const factory DUICardProps.eventName() = _eventName;",
            },
          ]
        },
        "spaceBtwAvatarImageAndText": "sp-200",
        "avatarImage": {
          "height": 24,
          "width": 24,
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
        "avatarText": {
          "styleClass": "ft:caption;tc:textSubtle",
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
