import 'dart:convert';

import 'package:digia_ui/src/components/DUIText/dui_text_props.dart';
import 'package:digia_ui/src/components/utils/DUIStyleClass/dui_style_class.dart';
import 'package:digia_ui/src/core/action/action_prop.dart';
import 'package:json_annotation/json_annotation.dart';

part 'button.props.g.dart';

@JsonSerializable()
class DUIButtonProps {
  // double? width;
  // double? height;
  // String? alignment;
  // String? backgroundColor;
  // DUIInsets? margin;
  // DUIInsets? padding;
  @JsonKey(
      fromJson: DUIStyleClass.fromJson, includeToJson: false, name: 'style')
  DUIStyleClass? styleClass;
  // String? shape;
  late DUITextProps text;
  String? disabledBackgroundColor;
  bool? disabled;
  ActionProp? onClick;
  bool? setLoading;

  DUIButtonProps();

  factory DUIButtonProps.fromJson(Map<String, dynamic> json) =>
      _$DUIButtonPropsFromJson(json);

  Map<String, dynamic> toJson() => _$DUIButtonPropsToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
