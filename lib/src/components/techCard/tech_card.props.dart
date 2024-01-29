import 'dart:convert';

import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/components/image/image.props.dart';
import 'package:digia_ui/src/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
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
  late ActionProp? onClick;
  DUITechCardProps();

  factory DUITechCardProps.fromJson(Map<String, dynamic> json) =>
      _$DUITechCardPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUITechCardPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
