import 'dart:convert';

import 'package:digia_ui/components/utils/DUICornerRadius/dui_corner_radius_props.dart';
import 'package:digia_ui/components/utils/DUIFit/dui_fit_props.dart';
import 'package:digia_ui/components/utils/DUIInsets/dui_insets_props.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image.props.g.dart';

@JsonSerializable()
class DUIImageProps {
  late double height = 100;
  late double width = 100;
  late String imageSrc;
  late int? aspectRatio;
  late String? placeHolder;
  late String? errorFallback;
  late DUIInsets margins;
  late DUIFit fit;
  late DUICornerRadius? cornerRadius;

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
      "height": 400,
      "width": 400,
      "placeHolder":"",
      "errorFallback":"",
      "aspectRatio":0,
      "imageSrc": "https://upload.wikimedia.org/wikipedia/commons/e/e7/Everest_North_Face_toward_Base_Camp_Tibet_Luca_Galuzzi_2006.jpg",
      "margins": {
        "top":12,
        "left":12,
        "right":12,
        "bottom":12
      },
      "fit": {
        "fit":"cover"
      },
      "cornerRadius": {
        "topRight":12,
        "topLeft":12,
        "bottomLeft":12,
        "bottomRight":12,
      }
    });
  }
}
