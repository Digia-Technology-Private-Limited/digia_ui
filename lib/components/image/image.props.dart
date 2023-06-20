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
}
