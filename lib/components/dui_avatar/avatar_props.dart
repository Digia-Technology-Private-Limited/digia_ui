import 'package:digia_ui/Utils/basic_shared_utils/color_decoder.dart';
import 'package:digia_ui/components/DUIText/dui_text.dart';
import 'package:digia_ui/components/dui_avatar/avatar.dart';
import 'package:digia_ui/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'avatar_props.g.dart';

class DUIAvatarProps {
  @JsonKey(fromJson: DUIStyleClass.fromJson, includeToJson: false)
  // Properties
  double? radius;
  AvatarShape? shape;
  Color? backgroundColor;
  Widget? image;
  DUIText? fallbackText;

  DUIAvatarProps({
    this.backgroundColor,
    this.radius,
    this.image,
    this.fallbackText,
  });

  factory DUIAvatarProps.fromJson(Map<String, dynamic> json) =>
      _$DUIAvatarPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIAvatarPropsToJson(this);
}
