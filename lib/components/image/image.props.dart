import 'dart:convert';

import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.props.g.dart';

@JsonSerializable()
class DUIImageProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  late DUIStyleClass? styleClass;
  late String imageSrc;
  late String? placeHolder;
  late String? errorImage;
  late double? aspectRatio;
  late String fit;

  DUIImageProps();

  factory DUIImageProps.fromJson(Map<String, dynamic> json) =>
      _$DUIImagePropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIImagePropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  DUIImageProps mockWidget() {
    return DUIImageProps.fromJson({
      "height": 300,
      "width": 300,
      "placeHolder": "",
      "errorFallback": "",
      "aspectRatio": 0,
      "imageSrc":
          "https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
      "fit": "cover",
      "cornerRadius": {
        "topRight": 12,
        "topLeft": 12,
        "bottomLeft": 12,
        "bottomRight": 12,
      }
    });
  }
}
