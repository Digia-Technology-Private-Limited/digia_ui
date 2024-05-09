import 'dart:convert';

import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/components/image/image.props.dart';
import 'package:digia_ui/src/components/utils/DUIInsets/dui_insets.dart';
import 'package:digia_ui/src/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dui_card_props.g.dart';

@JsonSerializable()
class DUICardProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  late DUIStyleClass? styleClass;
  late DUIInsets contentPadding;
  late DUIImageProps image;
  late DUITextProps title;
  late DUITextProps topCrumbText;
  late String spaceBtwTopCrumbTextTitle;
  late DUITextProps avatarText;
  late DUIImageProps avatarImage;
  late String spaceBtwAvatarImageAndText;

  DUICardProps();

  factory DUICardProps.fromJson(Map<String, dynamic> json) => _$DUICardPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUICardPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
